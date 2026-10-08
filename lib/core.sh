#!/usr/bin/env bash
# JFStack Linux Admin Toolkit - common bootstrap

set -o pipefail

JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
# shellcheck source=lib/output.sh
source "$JFSTACK_ROOT/lib/output.sh"
# shellcheck source=lib/logging.sh
source "$JFSTACK_ROOT/lib/logging.sh"
# shellcheck source=lib/validation.sh
source "$JFSTACK_ROOT/lib/validation.sh"
# shellcheck source=lib/platform.sh
source "$JFSTACK_ROOT/lib/platform.sh"

JFSTACK_VERSION="$(cat "$JFSTACK_ROOT/VERSION" 2>/dev/null || printf 'dev')"
