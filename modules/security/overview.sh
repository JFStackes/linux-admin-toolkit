#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"; source "$JFSTACK_ROOT/lib/core.sh"
banner; section 'SECURITY OVERVIEW'
printf 'Logged users:\n'; who || true
printf '\nUID 0 accounts:\n'; awk -F: '$3==0 {print " " $1}' /etc/passwd
printf '\nAccounts with expiration configured:\n'; if command -v chage >/dev/null 2>&1; then while IFS=: read -r u _ uid _; do [[ "$uid" -ge 1000 && "$u" != nobody ]] || continue; exp="$(chage -l "$u" 2>/dev/null | awk -F': ' '/Account expires/ {print $2}')"; [[ "$exp" != never && -n "$exp" ]] && printf ' %-24s %s\n' "$u" "$exp"; done </etc/passwd; fi
printf '\nListening sockets:\n'; if command -v ss >/dev/null 2>&1; then ss -lntup 2>/dev/null | head -n 60; fi
