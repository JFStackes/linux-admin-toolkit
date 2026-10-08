#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"; source "$JFSTACK_ROOT/lib/core.sh"
require_command systemctl
service="${1:-}"
banner; section 'SERVICES'
if [[ -n "$service" ]]; then
  systemctl --no-pager --full status "$service" || true
else
  printf 'Failed services:\n'
  systemctl --failed --no-pager || true
  printf '\nRunning services (first 40):\n'
  systemctl list-units --type=service --state=running --no-pager --no-legend | head -n 40
fi
