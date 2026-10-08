#!/usr/bin/env bash
set -euo pipefail
ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"; read -r -p 'Report path [current directory]: ' p; "$ROOT/modules/diagnostics/report.sh" "${p:-./jfstack-diagnostic-$(hostname)-$(date '+%Y%m%d-%H%M%S').txt}"; read -r -p 'Press Enter...' _
