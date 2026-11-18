#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
source "$JFSTACK_ROOT/lib/core.sh"
while true; do
  section 'USERS & GROUPS'
  printf '  1) Create user\n  2) User information\n  3) Change expiration\n  4) Reset password\n  5) Delete user\n  6) List local users\n  0) Back to main menu\n\n'
  read -r -p 'Select: ' choice || exit 0
  case "$choice" in
    1) run_menu_action "$JFSTACK_ROOT/modules/users/create-user.sh" || exit 0 ;;
    2) run_menu_action "$JFSTACK_ROOT/modules/users/user-info.sh" || exit 0 ;;
    3) run_menu_action "$JFSTACK_ROOT/modules/users/expire-user.sh" || exit 0 ;;
    4) run_menu_action "$JFSTACK_ROOT/modules/users/reset-password.sh" || exit 0 ;;
    5) run_menu_action "$JFSTACK_ROOT/modules/users/delete-user.sh" || exit 0 ;;
    6)
      # The dollar signs refer to awk fields.
      # shellcheck disable=SC2016
      run_menu_action awk -F: '$3 >= 1000 && $1 != "nobody" {printf "%-24s UID=%s HOME=%s\n",$1,$3,$6}' /etc/passwd || exit 0 ;;
    0) exit 0 ;;
    *) warn 'Invalid option.' ;;
  esac
done
