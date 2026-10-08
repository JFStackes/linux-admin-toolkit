#!/usr/bin/env bash
set -euo pipefail
ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"; "$ROOT/modules/system/summary.sh"; read -r -p 'Press Enter...' _
