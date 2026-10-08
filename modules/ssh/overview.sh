#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"; source "$JFSTACK_ROOT/lib/core.sh"
banner; section 'SSH OVERVIEW'
printf ' SSH port      : %s\n' "$(ssh_port)"
if command -v systemctl >/dev/null 2>&1; then
  for svc in sshd ssh; do systemctl list-unit-files "$svc.service" >/dev/null 2>&1 && { printf ' Service       : %s\n' "$svc"; systemctl is-active "$svc" 2>/dev/null | sed 's/^/ Status        : /'; break; }; done
fi
if command -v sshd >/dev/null 2>&1; then
  printf '\nEffective security settings:\n'
  sshd -T 2>/dev/null | awk '$1 ~ /^(port|permitrootlogin|passwordauthentication|pubkeyauthentication|maxauthtries|allowusers|allowgroups)$/ {printf " %-24s %s\n",$1,$2}' || true
fi
