#!/usr/bin/env bash
# JFStack Linux Admin Toolkit - operation logging

jfstack_log_file() {
  if [[ ${EUID:-$(id -u)} -eq 0 ]]; then
    printf '/var/log/jfstack-admin/jfstack-admin.log\n'
  else
    printf '%s/.local/state/jfstack-admin/jfstack-admin.log\n' "${HOME}"
  fi
}

log_event() {
  local level="$1"; shift
  local message="$*"
  local file dir
  file="$(jfstack_log_file)"
  dir="$(dirname "$file")"
  mkdir -p "$dir" 2>/dev/null || return 0
  chmod 750 "$dir" 2>/dev/null || true
  printf '%s [%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S%z')" "$level" "$message" >> "$file" 2>/dev/null || true
  chmod 640 "$file" 2>/dev/null || true
}
