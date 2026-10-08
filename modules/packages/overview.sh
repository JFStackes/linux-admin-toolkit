#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"; source "$JFSTACK_ROOT/lib/core.sh"
pm="$(pkg_manager)"
banner; section 'PACKAGES & UPDATES'
printf 'Package manager: %s\n\n' "$pm"
case "$pm" in
  apt-get) apt list --upgradable 2>/dev/null | head -n 80 ;;
  dnf) dnf -q check-update || rc=$?; [[ ${rc:-0} -eq 100 || ${rc:-0} -eq 0 ]] || true ;;
  yum) yum -q check-update || rc=$?; [[ ${rc:-0} -eq 100 || ${rc:-0} -eq 0 ]] || true ;;
  zypper) zypper -q list-updates || true ;;
  pacman) checkupdates 2>/dev/null || warn 'Install pacman-contrib for non-destructive update checks.' ;;
  *) warn 'Unsupported package manager.' ;;
esac
