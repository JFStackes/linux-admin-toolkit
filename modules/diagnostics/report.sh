#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"; source "$JFSTACK_ROOT/lib/core.sh"
out="${1:-}"
if [[ -z "$out" ]]; then out="./jfstack-diagnostic-$(hostname)-$(date '+%Y%m%d-%H%M%S').txt"; fi
mkdir -p "$(dirname "$out")"
{
  line
  printf ' JFSTACK LINUX ADMIN TOOLKIT\n DIAGNOSTIC REPORT\n'
  line
  printf ' Version    : %s\n' "$JFSTACK_VERSION"
  printf ' Generated  : %s\n' "$(date --iso-8601=seconds 2>/dev/null || date)"
  printf ' Hostname   : %s\n' "$(hostname -f 2>/dev/null || hostname)"
  printf ' OS         : %s\n' "$(os_pretty_name)"
  printf ' Kernel     : %s\n' "$(uname -r)"
  printf ' Primary IP : %s\n' "$(primary_ip)"
  printf ' SSH port   : %s\n' "$(ssh_port)"

  printf '\n===== UPTIME / LOAD =====\n'; uptime || true
  printf '\n===== MEMORY =====\n'; free -h 2>/dev/null || true
  printf '\n===== FILESYSTEMS =====\n'; df -hT -x tmpfs -x devtmpfs 2>/dev/null || df -h || true
  printf '\n===== INODES =====\n'; df -ih -x tmpfs -x devtmpfs 2>/dev/null || true
  printf '\n===== BLOCK DEVICES =====\n'; lsblk 2>/dev/null || true
  printf '\n===== NETWORK =====\n'; ip -brief address 2>/dev/null || true
  printf '\n===== ROUTES =====\n'; ip route 2>/dev/null || true
  printf '\n===== LISTENING PORTS =====\n'; ss -lntup 2>/dev/null || true
  printf '\n===== FAILED SERVICES =====\n'; systemctl --failed --no-pager 2>/dev/null || true
  printf '\n===== TOP CPU =====\n'; ps -eo pid,user,%cpu,%mem,etime,comm --sort=-%cpu 2>/dev/null | head -n 16 || true
  printf '\n===== TOP MEMORY =====\n'; ps -eo pid,user,%mem,%cpu,etime,comm --sort=-%mem 2>/dev/null | head -n 16 || true
  printf '\n===== DOCKER =====\n'; if command -v docker >/dev/null 2>&1; then docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}' 2>/dev/null || true; docker system df 2>/dev/null || true; else printf 'Docker not detected.\n'; fi
  printf '\n===== RECENT ERRORS =====\n'; if command -v journalctl >/dev/null 2>&1; then journalctl -p err..alert --since '24 hours ago' --no-pager -n 100 2>/dev/null || true; fi
} > "$out"
chmod 600 "$out" 2>/dev/null || true
log_event INFO "diagnostic.report path=$out"
ok "Diagnostic report generated: $out"
warn "Review the report before sharing it; system diagnostics can contain hostnames, IP addresses, usernames and other operational metadata."
