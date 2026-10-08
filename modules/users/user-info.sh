#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
source "$JFSTACK_ROOT/lib/core.sh"
user="${1:-}"
[[ -n "$user" ]] || { read -r -p 'Username: ' user; }
id "$user" >/dev/null 2>&1 || { error "User not found: $user"; exit 2; }
banner
section "USER INFORMATION"
getent passwd "$user" | awk -F: '{printf " Username   : %s\n UID        : %s\n GID        : %s\n Home       : %s\n Shell      : %s\n",$1,$3,$4,$6,$7}'
printf ' Groups     : %s\n' "$(id -nG "$user")"
if command -v chage >/dev/null 2>&1; then chage -l "$user" | sed 's/^/ /'; fi
home="$(getent passwd "$user" | cut -d: -f6)"
[[ -s "$home/.ssh/authorized_keys" ]] && printf ' SSH keys   : %s authorized key(s)\n' "$(grep -cve '^[[:space:]]*$' "$home/.ssh/authorized_keys")" || printf ' SSH keys   : 0\n'
line
