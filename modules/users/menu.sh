#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
source "$JFSTACK_ROOT/lib/core.sh"
while true; do
  banner; section 'USERS & GROUPS'
  printf '  1) Create user\n  2) User information\n  3) Change expiration\n  4) Reset password\n  5) Delete user\n  6) List local users\n  0) Back\n\n'
  read -r -p 'Select: ' choice
  case "$choice" in
    1) "$JFSTACK_ROOT/modules/users/create-user.sh"; read -r -p 'Press Enter...' _ ;;
    2) "$JFSTACK_ROOT/modules/users/user-info.sh"; read -r -p 'Press Enter...' _ ;;
    3) "$JFSTACK_ROOT/modules/users/expire-user.sh"; read -r -p 'Press Enter...' _ ;;
    4) "$JFSTACK_ROOT/modules/users/reset-password.sh"; read -r -p 'Press Enter...' _ ;;
    5) "$JFSTACK_ROOT/modules/users/delete-user.sh"; read -r -p 'Press Enter...' _ ;;
    6) awk -F: '$3 >= 1000 && $1 != "nobody" {printf "%-24s UID=%s HOME=%s\n",$1,$3,$6}' /etc/passwd; read -r -p 'Press Enter...' _ ;;
    0) exit 0 ;;
    *) warn 'Invalid option.' ;;
  esac
done
