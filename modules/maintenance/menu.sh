#!/usr/bin/env bash
set -euo pipefail
ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"; "$ROOT/modules/maintenance/overview.sh"; read -r -p 'Press Enter...' _
