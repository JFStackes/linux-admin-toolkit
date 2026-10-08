#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"; source "$JFSTACK_ROOT/lib/core.sh"
banner; section 'SYSTEM SUMMARY'
printf ' Hostname   : %s\n' "$(hostname -f 2>/dev/null || hostname)"
printf ' OS         : %s\n' "$(os_pretty_name)"
printf ' Kernel     : %s\n' "$(uname -r)"
printf ' Architecture: %s\n' "$(uname -m)"
printf ' Uptime     : %s\n' "$(uptime -p 2>/dev/null || uptime)"
printf ' Load       : %s\n' "$(awk '{print $1, $2, $3}' /proc/loadavg 2>/dev/null || printf 'N/A')"
printf ' CPU cores  : %s\n' "$(getconf _NPROCESSORS_ONLN 2>/dev/null || nproc 2>/dev/null || printf 'N/A')"
if command -v free >/dev/null 2>&1; then free -h | sed 's/^/ /'; fi
printf ' Primary IP : %s\n' "$(primary_ip)"
printf ' SSH port   : %s\n' "$(ssh_port)"
printf ' Pkg manager: %s\n' "$(pkg_manager)"
line
