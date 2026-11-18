#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
# shellcheck source=lib/core.sh
source "$JFSTACK_ROOT/lib/core.sh"
cli="$JFSTACK_ROOT/bin/jfstack-admin"

while true; do
  section 'SOFTWARE & CONTAINERS'
  cat <<'MENU'
  1) Check available package updates
  2) Docker status
  0) Back to main menu

MENU
  read -r -p 'Select: ' choice || exit 0
  case "$choice" in
    1) args=(packages updates) ;;
    2) args=(docker status) ;;
    0) exit 0 ;;
    *) warn 'Invalid option.'; continue ;;
  esac

  run_menu_action "$cli" "${args[@]}" || exit 0
done
