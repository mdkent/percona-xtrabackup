########################################################################
# Test that --extra-file is included in a stream backup
########################################################################

. inc/common.sh

start_server

rm -rf $topdir/random
mkdir -p $topdir/random/dir
echo "123" > $topdir/random/dir/an_extra_file1
echo "456" > $topdir/random/dir/an_extra_file2

# take a backup with stream mode
mkdir -p $topdir/backup
innobackupex --stream=tar \
  --extra-file=$topdir/random/dir/an_extra_file1 \
  --extra-file=$topdir/random/dir/an_extra_file2 \
  $topdir/backup > $topdir/backup/stream.tar

if $TAR itf $topdir/backup/stream.tar | grep ^./an_extra_file -c | grep 2; then
    vlog "--extra-file was backed up"
else
    vlog "--extra-file was not backed up"
    exit -1
fi
