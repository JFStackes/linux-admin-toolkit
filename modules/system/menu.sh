#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
# shellcheck source=lib/core.sh
source "$JFSTACK_ROOT/lib/core.sh"
cli="$JFSTACK_ROOT/bin/jfstack-admin"

while true; do
  section 'SYSTEM & SERVICES'
  cat <<'MENU'
  1) System summary
  2) Inspect a service
  3) Processes using the most CPU
  4) Processes using the most memory
  0) Back to main menu

MENU
  read -r -p 'Select: ' choice || exit 0
  case "$choice" in
    1) args=(system info) ;;
    2)
      read -r -p 'Service name [Enter to cancel]: ' service || exit 0
      [[ -n $service ]] || continue
      args=(service status "$service") ;;
    3) args=(process top cpu) ;;
    4) args=(process top mem) ;;
    0) exit 0 ;;
    *) warn 'Invalid option.'; continue ;;
  esac

  run_menu_action "$cli" "${args[@]}" || exit 0
done
