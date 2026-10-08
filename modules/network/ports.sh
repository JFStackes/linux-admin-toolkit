#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"; source "$JFSTACK_ROOT/lib/core.sh"
banner; section 'LISTENING PORTS'
if command -v ss >/dev/null 2>&1; then ss -lntup; elif command -v netstat >/dev/null 2>&1; then netstat -lntup; else error 'Neither ss nor netstat is available.'; exit 1; fi
