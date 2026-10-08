#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
source "$JFSTACK_ROOT/lib/core.sh"
require_root
user="${1:-}"; shift || true
remove_home=false; force=false
while [[ $# -gt 0 ]]; do case "$1" in --remove-home) remove_home=true;; --yes) force=true;; *) error "Unknown option: $1"; exit 2;; esac; shift; done
[[ -n "$user" ]] || read -r -p 'Username: ' user
id "$user" >/dev/null 2>&1 || { error "User not found: $user"; exit 2; }
if [[ "$force" != true ]]; then yes_no "Delete user '$user'?" N || { info 'Cancelled.'; exit 0; }; fi
args=(); [[ "$remove_home" == true ]] && args+=(--remove)
userdel "${args[@]}" "$user"
log_event INFO "user.delete user=$user remove_home=$remove_home"
ok "User deleted: $user"
