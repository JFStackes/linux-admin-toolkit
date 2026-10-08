#!/usr/bin/env bash
set -euo pipefail
ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"; read -r -p 'Backup path: ' p; "$ROOT/modules/backups/check-path.sh" "$p"; read -r -p 'Press Enter...' _
