#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"; source "$JFSTACK_ROOT/lib/core.sh"
banner; section 'ACTIVE LOGIN SESSIONS'; who || true
section 'SSH CONNECTIONS'; if command -v ss >/dev/null 2>&1; then ss -tnp 2>/dev/null | awk 'NR==1 || /sshd/'; fi
