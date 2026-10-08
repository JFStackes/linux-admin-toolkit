#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"; source "$JFSTACK_ROOT/lib/core.sh"
mode="${1:-cpu}"
banner; section "TOP PROCESSES BY ${mode^^}"
case "$mode" in
  cpu) ps -eo pid,user,%cpu,%mem,etime,comm --sort=-%cpu | head -n 16 ;;
  mem|memory) ps -eo pid,user,%mem,%cpu,etime,comm --sort=-%mem | head -n 16 ;;
  *) error 'Usage: top.sh [cpu|mem]'; exit 2 ;;
esac
