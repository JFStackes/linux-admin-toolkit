#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"; source "$JFSTACK_ROOT/lib/core.sh"
banner; section 'MAINTENANCE OVERVIEW'
printf 'Disk pressure:\n'; df -hP -x tmpfs -x devtmpfs 2>/dev/null | awk 'NR==1 || $5+0 >= 80'
printf '\nJournal usage:\n'; command -v journalctl >/dev/null 2>&1 && journalctl --disk-usage 2>/dev/null || true
printf '\nFailed services:\n'; command -v systemctl >/dev/null 2>&1 && systemctl --failed --no-pager || true
printf '\nReboot required:\n'; [[ -e /var/run/reboot-required ]] && cat /var/run/reboot-required || printf ' Not indicated by the distribution.\n'
