#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"; source "$JFSTACK_ROOT/lib/core.sh"
path="${1:-}"
[[ -n "$path" ]] || read -r -p 'Backup path: ' path
[[ -e "$path" ]] || { error "Path not found: $path"; exit 2; }
banner; section "BACKUP PATH CHECK: $path"
du -sh "$path" 2>/dev/null || true
printf '\nNewest files:\n'; find "$path" -type f -printf '%T@ %TY-%Tm-%Td %TH:%TM %s %p\n' 2>/dev/null | sort -nr | head -n 20 | cut -d' ' -f2-
