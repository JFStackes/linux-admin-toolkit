#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"; source "$JFSTACK_ROOT/lib/core.sh"
target="${1:-1.1.1.1}"
banner; section "CONNECTIVITY TEST: $target"
ping -c 3 -W 2 "$target" || true
if command -v getent >/dev/null 2>&1; then section 'DNS LOOKUP'; getent ahosts "$target" 2>/dev/null | head -n 10 || true; fi
