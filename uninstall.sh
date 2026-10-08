#!/usr/bin/env bash
# JFStack Linux Admin Toolkit uninstaller
set -euo pipefail
[[ ${EUID:-$(id -u)} -eq 0 ]] || { echo '[ERROR] Run with sudo/root.' >&2; exit 1; }
read -r -p 'Remove /opt/jfstack-admin and /usr/local/bin/jfstack-admin? [y/N]: ' answer
[[ "$answer" =~ ^[Yy]$ ]] || { echo 'Cancelled.'; exit 0; }
rm -f /usr/local/bin/jfstack-admin
rm -rf /opt/jfstack-admin
printf 'JFStack Linux Admin Toolkit removed. Logs and generated keys/reports were not removed.\n'
