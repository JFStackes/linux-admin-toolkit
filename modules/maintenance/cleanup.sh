#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
# shellcheck source=lib/core.sh
source "$JFSTACK_ROOT/lib/core.sh"

usage() {
  error 'Use: maintenance clean-cache|clean-updates|rotate-logs|clean-temp [--dry-run|--yes]'
  error 'Use: maintenance vacuum-journal [DAYS (1-9999)] [--dry-run|--yes]'
  exit 2
}

[[ $# -gt 0 ]] || usage
action=$1
shift
mode=confirm
days=''
for arg in "$@"; do
  case "$arg" in
    --dry-run|--yes)
      [[ $mode == confirm ]] || usage
      mode=$arg ;;
    *)
      [[ $action == vacuum-journal && -z $days && $arg =~ ^[1-9][0-9]{0,3}$ ]] || usage
      days=$arg ;;
  esac
done

case "$action" in
  clean-cache|clean-updates)
    manager=$(pkg_manager)
    case "$manager:$action" in
      apt-get:clean-cache|dnf:clean-cache|yum:clean-cache)
        description='Remove downloaded packages from the package cache.'
        if [[ $manager == apt-get ]]; then
          operation=(apt-get clean)
        else
          operation=("$manager" clean packages)
        fi ;;
      apt-get:clean-updates)
        description='Remove cached package files that are no longer downloadable.'
        operation=(apt-get autoclean) ;;
      dnf:clean-updates|yum:clean-updates)
        description='Remove cached repository metadata. The package manager will download it again when needed.'
        operation=("$manager" clean metadata) ;;
      *) error 'Package cleanup requires apt-get, dnf, or yum.'; exit 1 ;;
    esac ;;
  rotate-logs)
    description='Rotate logs and apply retention according to /etc/logrotate.conf.'
    operation=(logrotate /etc/logrotate.conf) ;;
  vacuum-journal)
    days=${days:-30}
    description="Remove archived system journal files older than $days days."
    operation=(journalctl --system "--vacuum-time=${days}days") ;;
  clean-temp)
    description='Clean expired files under /tmp and /var/tmp according to system tmpfiles.d rules.'
    operation=(systemd-tmpfiles --clean --prefix=/tmp --prefix=/var/tmp) ;;
  *) usage ;;
esac

require_command "${operation[0]}"
if [[ $action == rotate-logs && ! -r /etc/logrotate.conf ]]; then
  error 'Cannot read /etc/logrotate.conf.'
  exit 1
fi

info "$description"
printf 'Command:'
printf ' %q' "${operation[@]}"
printf '\n'

if [[ $mode == --dry-run ]]; then
  info 'Preview only. The command was not executed.'
  exit 0
fi

require_root
if [[ $mode == confirm ]]; then
  if [[ ! -t 0 ]]; then
    error 'Use an interactive terminal to confirm, or pass --yes to run unattended.'
    exit 1
  fi
  if ! yes_no 'Proceed with this cleanup?'; then
    info 'Cancelled.'
    exit 0
  fi
fi

log_event INFO "maintenance.$action.started"
if "${operation[@]}"; then
  log_event INFO "maintenance.$action.completed"
  ok 'Operation completed.'
else
  status=$?
  log_event WARN "maintenance.$action.failed exit=$status"
  error "Cleanup failed (exit $status). Review the command output before retrying."
  exit "$status"
fi
