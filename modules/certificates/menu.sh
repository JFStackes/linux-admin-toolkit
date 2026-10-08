#!/usr/bin/env bash
set -euo pipefail
ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"; read -r -p 'Host[:port]: ' h; "$ROOT/modules/certificates/check.sh" "$h"; read -r -p 'Press Enter...' _
