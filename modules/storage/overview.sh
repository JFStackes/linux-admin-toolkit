#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"; source "$JFSTACK_ROOT/lib/core.sh"
banner; section 'STORAGE OVERVIEW'
df -hT -x tmpfs -x devtmpfs 2>/dev/null || df -h
if command -v lsblk >/dev/null 2>&1; then section 'BLOCK DEVICES'; lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINTS; fi
section 'INODES'; df -ih -x tmpfs -x devtmpfs 2>/dev/null || true
