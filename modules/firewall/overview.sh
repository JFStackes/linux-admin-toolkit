#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"; source "$JFSTACK_ROOT/lib/core.sh"
banner; section 'FIREWALL OVERVIEW'
if command -v ufw >/dev/null 2>&1; then
  printf 'Detected: UFW\n'; ufw status verbose || true
elif command -v firewall-cmd >/dev/null 2>&1; then
  printf 'Detected: firewalld\n'; firewall-cmd --state || true; firewall-cmd --list-all || true
elif command -v nft >/dev/null 2>&1; then
  printf 'Detected: nftables\n'; nft list ruleset 2>/dev/null | head -n 160 || true
elif command -v iptables >/dev/null 2>&1; then
  printf 'Detected: iptables\n'; iptables -S 2>/dev/null | head -n 160 || true
else
  warn 'No supported firewall command detected.'
fi
