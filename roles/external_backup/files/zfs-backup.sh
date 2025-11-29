#!/usr/bin/env bash
set -euo pipefail
trap 'log_and_notify_error "An error occurred during the backup process."' ERR

DRIVE_ID="$1"
DEVICE_PATH="/dev/disk/by-id/ata-$DRIVE_ID"

log_and_notify_error() {
  local message="$1"
  logger -t zfs-backup "ERROR: $message"
  apprise -t 'Backup failed' -b "$message"
  udisksctl power-off -b "$DEVICE_PATH"
  exit 1
}

if [[ -z "$DRIVE_ID" || ! -e "$DEVICE_PATH" ]]; then
  log_and_notify_error "Invalid or missing drive ID: $DRIVE_ID"
fi

logger -t zfs-backup "Starting backup for drive $DRIVE_ID"
apprise -t 'Backup started' -b 'External drive syncing ZFS datasets'

zpool import hdd
/usr/sbin/syncoid -r --no-sync-snap --sendoptions=w rpool hdd/backup/cepheus-rpool
zpool export hdd
udisksctl power-off -b "$DEVICE_PATH"

logger -t zfs-backup "Backup completed for $DRIVE_ID"
apprise -t 'Backup completed' -b 'External drive powered off'