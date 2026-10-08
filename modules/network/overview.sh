#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"; source "$JFSTACK_ROOT/lib/core.sh"
banner; section 'NETWORK OVERVIEW'
printf ' Primary IP : %s\n' "$(primary_ip)"
printf ' Hostname   : %s\n' "$(hostname -f 2>/dev/null || hostname)"
printf '\nInterfaces:\n'; ip -brief address 2>/dev/null || ip addr
printf '\nRoutes:\n'; ip route 2>/dev/null || true
printf '\nDNS:\n'; if command -v resolvectl >/dev/null 2>&1; then resolvectl status 2>/dev/null | head -n 60; else cat /etc/resolv.conf; fi
