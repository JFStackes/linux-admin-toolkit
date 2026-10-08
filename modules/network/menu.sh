#!/usr/bin/env bash
set -euo pipefail
ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"; printf '1) Network overview\n2) Listening ports\n3) Connectivity test\n0) Back\n'; read -r -p 'Select: ' c; case "$c" in 1) "$ROOT/modules/network/overview.sh";; 2) "$ROOT/modules/network/ports.sh";; 3) read -r -p 'Target [1.1.1.1]: ' t; "$ROOT/modules/network/test.sh" "${t:-1.1.1.1}";; esac; read -r -p 'Press Enter...' _
