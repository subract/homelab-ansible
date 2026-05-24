#!/usr/bin/env bash
set -euo pipefail

HC_URL="{{ remote_backup_healthcheck_id }}"

hc_ping() {
  local endpoint="${1:-}"
  curl -fsS -m 10 --retry 3 -o /dev/null "${HC_URL}${endpoint}" || true
}

on_error() {
  local exit_code=$?
  logger -t zfs-remote-backup "ERROR: remote backup failed (exit $exit_code)"
  hc_ping "/fail"
  exit "$exit_code"
}
trap on_error ERR

logger -t zfs-remote-backup "Starting remote backup of {{ remote_backup_src_filesystem }} to {{ remote_backup_host }}:{{ remote_backup_dst_filesystem }}"
hc_ping "/start"

/usr/sbin/syncoid \
  -r \
  --no-sync-snap \
  --no-privilege-elevation \
  --sshkey /root/.ssh/id_ed25519 \
  {{ remote_backup_src_filesystem }} \
  {{ remote_backup_user }}@{{ remote_backup_host }}:{{ remote_backup_dst_filesystem }}

logger -t zfs-remote-backup "Backup completed for ${DRIVE_ID:-unknown}"
hc_ping
