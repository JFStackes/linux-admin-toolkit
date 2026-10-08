#!/usr/bin/env bash
set -euo pipefail
ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"; printf '1) SSH overview\n2) Active sessions\n0) Back\n'; read -r -p 'Select: ' c; case "$c" in 1) "$ROOT/modules/ssh/overview.sh";; 2) "$ROOT/modules/ssh/sessions.sh";; esac; read -r -p 'Press Enter...' _
