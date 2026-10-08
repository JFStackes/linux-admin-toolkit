#!/usr/bin/env bash
set -euo pipefail
ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"; printf '1) Top CPU\n2) Top memory\n0) Back\n'; read -r -p 'Select: ' c; case "$c" in 1) "$ROOT/modules/processes/top.sh" cpu;; 2) "$ROOT/modules/processes/top.sh" mem;; esac; read -r -p 'Press Enter...' _
