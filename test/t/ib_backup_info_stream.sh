########################################################################
# Test that xtrabackup_backup_info is included in a stream backup 
########################################################################

. inc/common.sh

start_server

# take a backup with stream mode
mkdir -p $topdir/backup
innobackupex --stream=tar $topdir/backup > $topdir/backup/stream.tar

if $TAR itf $topdir/backup/stream.tar | grep ^./xtrabackup_backup_info; then
    vlog "xtrabackup_backup_info was backed up"
else
    vlog "xtrabackup_backup_info was not backed up"
    exit -1
fi
