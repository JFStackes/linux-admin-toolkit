#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
# shellcheck source=lib/core.sh
source "$JFSTACK_ROOT/lib/core.sh"
cli="$JFSTACK_ROOT/bin/jfstack-admin"

while true; do
  section 'NETWORK & SECURITY'
  cat <<'MENU'
  1) Network interfaces, routes and DNS
  2) Listening ports
  3) SSH configuration
  4) Active SSH sessions
  5) Firewall status
  6) Security overview
  0) Back to main menu

MENU
  read -r -p 'Select: ' choice || exit 0
  case "$choice" in
    1) args=(network info) ;;
    2) args=(network ports) ;;
    3) args=(ssh info) ;;
    4) args=(ssh sessions) ;;
    5) args=(firewall status) ;;
    6) args=(security overview) ;;
    0) exit 0 ;;
    *) warn 'Invalid option.'; continue ;;
  esac

  run_menu_action "$cli" "${args[@]}" || exit 0
done
