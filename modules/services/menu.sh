#!/usr/bin/env bash
set -euo pipefail
ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
printf '1) Overview / failed services\n2) Inspect service\n0) Back\n'; read -r -p 'Select: ' c
case "$c" in 1) "$ROOT/modules/services/status.sh";; 2) read -r -p 'Service: ' s; "$ROOT/modules/services/status.sh" "$s";; esac
read -r -p 'Press Enter...' _
