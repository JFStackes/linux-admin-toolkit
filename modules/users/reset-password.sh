#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
source "$JFSTACK_ROOT/lib/core.sh"
require_root
user="${1:-}"; [[ -n "$user" ]] || read -r -p 'Username: ' user
id "$user" >/dev/null 2>&1 || { error "User not found: $user"; exit 2; }
if command -v openssl >/dev/null 2>&1; then random_hex="$(openssl rand -hex 16)"; else random_hex="$(od -An -N16 -tx1 /dev/urandom | tr -d ' \n')"; fi
pass="J9!${random_hex:0:20}#"
printf '%s:%s\n' "$user" "$pass" | chpasswd
log_event INFO "password.reset user=$user source=generated"
line; printf ' JFSTACK | PASSWORD RESET\n'; line
printf ' Username : %s\n Password : %s\n' "$user" "$pass"
line
