########################################################################
# Test that xtrabackup_backup_info is included in a rsynced backup
########################################################################

. inc/common.sh

start_server

# take a backup with stream mode
innobackupex --rsync --no-timestamp $topdir/backup

if [ -f $topdir/backup/xtrabackup_backup_info ] ; then
    vlog "xtrabackup_backup_info was backed up"
else
    vlog "xtrabackup_backup_info was not backed up"
    exit -1
fi
