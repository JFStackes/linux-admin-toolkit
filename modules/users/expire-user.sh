#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
source "$JFSTACK_ROOT/lib/core.sh"
require_root
user="${1:-}"; value="${2:-}"
[[ -n "$user" ]] || read -r -p 'Username: ' user
id "$user" >/dev/null 2>&1 || { error "User not found: $user"; exit 2; }
if [[ -z "$value" ]]; then read -r -p 'Expiration (none|1d|7d|1m|1y|YYYY-MM-DD): ' value; fi
case "$value" in
  none|never) chage -E -1 "$user"; resolved='none' ;;
  24h|1d) resolved="$(date -d '+1 day' +%F)"; chage -E "$resolved" "$user" ;;
  7d) resolved="$(date -d '+7 days' +%F)"; chage -E "$resolved" "$user" ;;
  1m) resolved="$(date -d '+1 month' +%F)"; chage -E "$resolved" "$user" ;;
  1y) resolved="$(date -d '+1 year' +%F)"; chage -E "$resolved" "$user" ;;
  ????-??-??) date -d "$value" +%F >/dev/null 2>&1 || { error 'Invalid date'; exit 2; }; resolved="$value"; chage -E "$resolved" "$user" ;;
  *) error 'Unsupported expiration value'; exit 2 ;;
esac
log_event INFO "user.expiration.set user=$user expiration=$resolved"
ok "Expiration updated for $user: $resolved"
