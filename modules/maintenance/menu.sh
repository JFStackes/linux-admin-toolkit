#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
# shellcheck source=lib/core.sh
source "$JFSTACK_ROOT/lib/core.sh"
cli="$JFSTACK_ROOT/bin/jfstack-admin"

while true; do
  banner
  section 'ANALYSIS & CLEANUP'
  cat <<'MENU'
  1) Maintenance overview
  2) Disk space and inode usage
  3) Largest subdirectories
  4) Largest files
  5) Clean package download cache
  6) Clean update leftovers
  7) Rotate logs according to system policy
  8) Remove old journal archives
  9) Clean expired temporary files
  0) Back

MENU
  read -r -p 'Select: ' choice || exit 0
  case "$choice" in
    1) args=(maintenance overview) ;;
    2) args=(storage info) ;;
    3|4)
      action=large-dirs
      if [[ $choice == 4 ]]; then action=large-files; fi
      IFS= read -r -p 'Directory to scan [/]: ' directory || exit 0
      read -r -p 'Maximum results [10]: ' limit || exit 0
      args=(maintenance "$action" "${directory:-/}" "${limit:-10}") ;;
    5) args=(maintenance clean-cache) ;;
    6) args=(maintenance clean-updates) ;;
    7) args=(maintenance rotate-logs) ;;
    8)
      read -r -p 'Remove archived journals older than how many days? [30]: ' days || exit 0
      args=(maintenance vacuum-journal "${days:-30}") ;;
    9) args=(maintenance clean-temp) ;;
    0) exit 0 ;;
    *) warn 'Invalid option.'; continue ;;
  esac

  "$cli" "${args[@]}" || warn "Operation exited with status $?."
  read -r -p 'Press Enter...' _ || exit 0
done
