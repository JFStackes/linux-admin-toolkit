#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"; source "$JFSTACK_ROOT/lib/core.sh"
banner; section 'DOCKER OVERVIEW'
if ! command -v docker >/dev/null 2>&1; then warn 'Docker is not installed or not in PATH.'; exit 0; fi
docker version --format 'Server: {{.Server.Version}}' 2>/dev/null || docker version 2>/dev/null | head -n 20 || true
printf '\nContainers:\n'; docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}' 2>/dev/null || true
printf '\nDisk usage:\n'; docker system df 2>/dev/null || true
