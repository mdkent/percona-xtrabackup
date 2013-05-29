########################################################################
# Test that xtrabackup_backup_info is included in a copied backup
########################################################################

. inc/common.sh

start_server

# take a backup with stream mode
innobackupex --no-timestamp $topdir/backup

mysql_version=`${MYSQL} ${MYSQL_ARGS} -Ns -e "select version()"`
xtrabackup_version=`xtrabackup -v 2>&1 | cut -d" " -f3`

if [ -f $topdir/backup/xtrabackup_backup_info ] ; then
    vlog "xtrabackup_backup_info was backed up"
else
    vlog "xtrabackup_backup_info was not backed up"
    exit -1
fi

if grep "$mysql_version" $topdir/backup/xtrabackup_backup_info; then
    vlog "found $mysql_version in xtrabackup_backup_info"
else
    vlog "couldn't find $mysql_version in xtrabackup_backup_info"
    exit -1
fi  

if grep "$xtrabackup_version" $topdir/backup/xtrabackup_backup_info; then
    vlog "found $xtrabackup_version in xtrabackup_backup_info"
else
    vlog "couldn't find $xtrabackup_version in xtrabackup_backup_info"
    exit -1
fi
