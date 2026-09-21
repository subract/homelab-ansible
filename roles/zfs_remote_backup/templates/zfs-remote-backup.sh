#!/usr/bin/env bash
set -euo pipefail

HC_URL="{{ remote_backup.healthcheck_id }}"

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

hc_ping "/start"

{% if remote_backup.wol_mac is defined and remote_backup.wol_mac %}
logger -t zfs-remote-backup "Sending WOL packet to {{ remote_backup.wol_mac }}"
wakeonlan {{ remote_backup.wol_mac }}

logger -t zfs-remote-backup "Waiting for {{ remote_backup.host }} to come online"
ELAPSED=0
until timeout 5 bash -c "echo > /dev/tcp/{{ remote_backup.host }}/22" 2>/dev/null; do
  if [ "$ELAPSED" -ge 300 ]; then
    logger -t zfs-remote-backup "ERROR: {{ remote_backup.host }} did not come online within 5 minutes"
    hc_ping "/fail"
    exit 1
  fi
  sleep 10
  ELAPSED=$((ELAPSED + 10))
done
logger -t zfs-remote-backup "{{ remote_backup.host }} is online"

{% endif %}
FAILED=0

{% for dataset in remote_backup.datasets %}
logger -t zfs-remote-backup "Starting remote backup of {{ dataset.src }} to {{ remote_backup.host }}:{{ dataset.dest }}"
if /usr/sbin/syncoid \
  -r \
  --no-sync-snap \
  --no-privilege-elevation \
  --sshkey {{ remote_backup.ssh_key | default('/root/.ssh/id_ed25519') }} \
{% if dataset.raw | default(false) %}  --sendoptions=w \
{% endif %}  {{ dataset.src }} \
  {{ remote_backup.user }}@{{ remote_backup.host }}:{{ dataset.dest }}; then
  logger -t zfs-remote-backup "Backup completed for {{ dataset.src }}"
else
  logger -t zfs-remote-backup "ERROR: backup failed for {{ dataset.src }}"
  FAILED=1
fi

{% endfor %}
if [ "$FAILED" -ne 0 ]; then
  logger -t zfs-remote-backup "ERROR: one or more dataset backups failed"
  hc_ping "/fail"
  exit 1
fi

hc_ping
