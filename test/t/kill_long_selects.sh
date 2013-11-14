############################################################################
# Test kill-long-queries and kill-long-queries-timeout optins
############################################################################

. inc/common.sh

function bg_run()
{
    local varname=$1

    shift

    ( for cmd in "$@"
      do
        eval "$cmd"
      done ) &

    local pid=$!

    eval "$varname=$pid"

}

function mysql_select()
{
    vlog "Run select query with duration $1 seconds"
    ${MYSQL} ${MYSQL_ARGS} -c test  2> /dev/null <<EOF
        /* Run background /*SELECT*\  */
        (
         SELECT SLEEP($1) FROM t1 FOR UPDATE
        ) UNION ALL
        (
         SELECT 1
        );
EOF
}

function mysql_update()
{
    vlog "Run update query with duration $1 seconds"
    ${MYSQL} ${MYSQL_ARGS} -c test 2> /dev/null <<EOF
        /* This is not SELECT but rather an /*UPDATE*\
        query  */
        UPDATE t1 SET a = SLEEP($1);
EOF
}


function bg_kill_ok()
{
    vlog "Killing $1, expecting it is alive"
    run_cmd kill $1
}


function bg_wait_ok()
{
    vlog "Waiting for $1, expecting it's success"
    run_cmd wait $1
}


function bg_wait_fail()
{
    vlog "Waiting for $1, expecting it would fail"
    run_cmd_expect_failure wait $1
}

function kill_all_queries()
{
  run_cmd $MYSQL $MYSQL_ARGS test <<EOF
  select concat('KILL ',id,';') from information_schema.processlist
  where user='root' and time > 2 into outfile '$MYSQLD_TMPDIR/killall.sql';
  source $MYSQLD_TMPDIR/killall.sql;
EOF
  rm -f $MYSQLD_TMPDIR/killall.sql
}

start_server --innodb_file_per_table

run_cmd $MYSQL $MYSQL_ARGS test <<EOF
CREATE TABLE t1(a INT) ENGINE=InnoDB;
INSERT INTO t1 VALUES (1);
EOF

mkdir $topdir/full

# ==============================================================
vlog "===================== case 1 ====================="
bg_run bg_select_pid "mysql_select 3"
bg_run bg_update_pid "sleep 1" "mysql_update 3"

innobackupex $topdir/full --kill-long-queries-timeout=5 \
                          --kill-long-query-type=all

bg_wait_ok $bg_select_pid
bg_wait_ok $bg_update_pid
kill_all_queries


# ==============================================================
vlog "===================== case 2 ====================="
bg_run bg_select_pid "mysql_select 200"
bg_run bg_update_pid "sleep 1" "mysql_update 5"

innobackupex $topdir/full --kill-long-queries-timeout=3 \
                          --kill-long-query-type=select

bg_wait_fail $bg_select_pid
bg_wait_ok $bg_update_pid
kill_all_queries


# ==============================================================
vlog "===================== case 3 ====================="
bg_run bg_select_pid "mysql_select 200"
bg_run bg_update_pid "mysql_update 200"

innobackupex $topdir/full --kill-long-queries-timeout=3 \
                          --kill-long-query-type=all

bg_wait_fail $bg_select_pid
bg_wait_fail $bg_update_pid
kill_all_queries


# ==============================================================
vlog "===================== case 4 ====================="
bg_run bg_select_pid "mysql_select 200"
bg_run bg_update_pid "mysql_update 200"

sleep 1

run_cmd_expect_failure ${IB_BIN} ${IB_ARGS} $topdir/full \
                          --lock-wait-timeout=3 \
                          --lock-wait-query-type=all \
                          --lock-wait-threshold=1 \
                          --kill-long-queries-timeout=1 \
                          --kill-long-query-type=all

bg_kill_ok $bg_select_pid
bg_kill_ok $bg_update_pid
kill_all_queries


# ==============================================================
vlog "===================== case 5 ====================="
bg_run bg_select_pid "mysql_select 200"
bg_run bg_update_pid "mysql_update 200"

sleep 2

run_cmd_expect_failure ${IB_BIN} ${IB_ARGS} $topdir/full \
                          --lock-wait-timeout=3 \
                          --lock-wait-query-type=update \
                          --lock-wait-threshold=2 \
                          --kill-long-queries-timeout=1 \
                          --kill-long-query-type=all

bg_kill_ok $bg_select_pid
bg_kill_ok $bg_update_pid
kill_all_queries


# ==============================================================
vlog "===================== case 6 ====================="
bg_run bg_update_pid "mysql_update 5"
bg_run bg_select_pid "sleep 1" "mysql_select 200"

sleep 2

innobackupex $topdir/full \
                          --lock-wait-timeout=6 \
                          --lock-wait-query-type=update \
                          --lock-wait-threshold=2 \
                          --kill-long-queries-timeout=1 \
                          --kill-long-query-type=all

bg_wait_fail $bg_select_pid
bg_wait_ok $bg_update_pid
kill_all_queries
