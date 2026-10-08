#!/usr/bin/env bash
# JFStack Linux Admin Toolkit - validation helpers

require_root() {
  if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
    error "This operation requires root privileges. Re-run with sudo."
    exit 1
  fi
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || { error "Required command not found: $1"; exit 1; }
}

valid_username() {
  [[ "$1" =~ ^[a-z_][a-z0-9_-]{0,31}$ ]]
}

yes_no() {
  local prompt="$1" default="${2:-N}" ans
  if [[ "$default" == "Y" ]]; then
    read -r -p "$prompt [Y/n]: " ans
    ans="${ans:-Y}"
  else
    read -r -p "$prompt [y/N]: " ans
    ans="${ans:-N}"
  fi
  [[ "$ans" =~ ^[Yy]$ ]]
}
