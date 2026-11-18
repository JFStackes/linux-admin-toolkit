#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
# shellcheck source=lib/core.sh
source "$JFSTACK_ROOT/lib/core.sh"
cli="$JFSTACK_ROOT/bin/jfstack-admin"

while true; do
  section 'DIAGNOSTICS'
  cat <<'MENU'
  1) Review recent system errors
  2) Review failed and running services
  3) Test connectivity
  4) Check a TLS certificate
  5) Check a backup directory
  6) Generate a diagnostic report
  0) Back to main menu

MENU
  read -r -p 'Select: ' choice || exit 0
  case "$choice" in
    1) args=(logs errors) ;;
    2) args=(service status) ;;
    3)
      read -r -p 'Target host or IP [1.1.1.1]: ' target || exit 0
      args=(network test "${target:-1.1.1.1}") ;;
    4)
      read -r -p 'Host[:port] [Enter to cancel]: ' host || exit 0
      [[ -n $host ]] || continue
      args=(cert check "$host") ;;
    5)
      IFS= read -r -p 'Backup directory [Enter to cancel]: ' path || exit 0
      [[ -n $path ]] || continue
      args=(backup check "$path") ;;
    6)
      IFS= read -r -p 'Report path [automatic filename in current directory]: ' path || exit 0
      if [[ -e $path || -L $path ]]; then
        if [[ ! -t 0 ]] || ! yes_no 'Replace the existing file?'; then
          info 'Report cancelled.'
          continue
        fi
      fi
      args=(diagnose "$path") ;;
    0) exit 0 ;;
    *) warn 'Invalid option.'; continue ;;
  esac

  run_menu_action "$cli" "${args[@]}" || exit 0
done
