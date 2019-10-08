#!/bin/bash

backupDir="/var/backup/luks"

test -d "$backupDir" || mkdir -p "$backupDir"

lsblk --fs --output FSTYPE,UUID | grep crypto_LUKS | tr -s ' ' | cut -d ' ' -f2 | \
while read uuid; do 
    mntPoint=`lsblk /dev/disk/by-uuid/$uuid --output MOUNTPOINT | sed 1,1d | tail -n 1 | tr '/' '_'`
    test "$mntPoint" || continue
    backupFile="$backupDir/luksHeader${mntPoint}_$uuid.img"
    if [[ ! -e "$backupFile" ]]; then
        cryptsetup luksHeaderBackup "/dev/disk/by-uuid/$uuid" --header-backup-file "$backupFile"
    fi
done
