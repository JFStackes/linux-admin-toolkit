#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
# shellcheck source=lib/core.sh
source "$JFSTACK_ROOT/lib/core.sh"
cli="$JFSTACK_ROOT/bin/jfstack-admin"
view=analysis

while true; do
  if [[ $view == analysis ]]; then
    section 'ANALYSIS & CLEANUP'
    cat <<'MENU'
  1) Disk space, inodes and block devices
  2) Find the largest directories
  3) Find the largest files
  4) Show system journal disk usage
  5) Cleanup options
  0) Back to main menu

MENU
  else
    section 'ANALYSIS & CLEANUP / CLEANUP OPTIONS'
    cat <<'MENU'
  1) Clean all available items
  2) Clean package download cache
  3) Clean update leftovers
  4) Rotate logs due under system policy
  5) Remove old journal archives
  6) Clean expired temporary files
  0) Back to Analysis & Cleanup

  Each action shows its scope before asking for confirmation.

MENU
  fi

  read -r -p 'Select: ' choice || exit 0
  case "$view:$choice" in
    analysis:1) args=(storage info) ;;
    analysis:2|analysis:3)
      action=large-dirs
      if [[ $choice == 3 ]]; then action=large-files; fi
      IFS= read -r -p 'Directory to scan [/]: ' directory || exit 0
      read -r -p 'Maximum results [10]: ' limit || exit 0
      args=(maintenance "$action" "${directory:-/}" "${limit:-10}") ;;
    analysis:4) args=(maintenance journal-usage) ;;
    analysis:5) view=cleanup; continue ;;
    analysis:0) exit 0 ;;
    cleanup:1|cleanup:5)
      action=clean-all
      if [[ $choice == 5 ]]; then action=vacuum-journal; fi
      read -r -p 'Days of journal archives to keep [30]: ' days || exit 0
      args=(maintenance "$action" "${days:-30}") ;;
    cleanup:2) args=(maintenance clean-cache) ;;
    cleanup:3) args=(maintenance clean-updates) ;;
    cleanup:4) args=(maintenance rotate-logs) ;;
    cleanup:6) args=(maintenance clean-temp) ;;
    cleanup:0) view=analysis; continue ;;
    *) warn 'Invalid option.'; continue ;;
  esac

  run_menu_action "$cli" "${args[@]}" || exit 0
done
