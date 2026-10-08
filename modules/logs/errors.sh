#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"; source "$JFSTACK_ROOT/lib/core.sh"
banner; section 'RECENT SYSTEM ERRORS'
if command -v journalctl >/dev/null 2>&1; then
  journalctl -p err..alert --since '24 hours ago' --no-pager -n 120 || true
else
  for f in /var/log/syslog /var/log/messages; do [[ -r "$f" ]] && tail -n 120 "$f"; done
fi
