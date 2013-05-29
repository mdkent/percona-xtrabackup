########################################################################
# Test that --extra-file is included in a copied backup
########################################################################

. inc/common.sh

start_server

rm -rf $topdir/random
mkdir -p $topdir/random/dir
echo "123" > $topdir/random/dir/an_extra_file1
echo "456" > $topdir/random/dir/an_extra_file2

# take a backup with stream mode
innobackupex --no-timestamp \
  --extra-file=$topdir/random/dir/an_extra_file1 \
  --extra-file=$topdir/random/dir/an_extra_file2 \
  $topdir/backup

if [ -f $topdir/backup/an_extra_file1 -a -f $topdir/backup/an_extra_file2 ] ; then
    vlog "--extra-file was backed up"
else
    vlog "--extra-file was not backed up"
    exit -1
fi

if grep "123" $topdir/backup/an_extra_file1; then
    vlog "content of an_extra_file1 is as expected"
else
    vlog "content of an_extra_file1 is as expected"
    exit -1
fi

if grep "456" $topdir/backup/an_extra_file2; then
    vlog "content of an_extra_file2 is as expected"
else
    vlog "content of an_extra_file2 is as expected"
    exit -1
fi
