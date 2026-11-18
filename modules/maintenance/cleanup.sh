#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
# shellcheck source=lib/core.sh
source "$JFSTACK_ROOT/lib/core.sh"

usage() {
  error 'Use: maintenance clean-cache|clean-updates|rotate-logs|clean-temp [--dry-run|--yes]'
  error 'Use: maintenance clean-all|vacuum-journal [DAYS (1-9999)] [--dry-run|--yes]'
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
      [[ ( $action == vacuum-journal || $action == clean-all ) && -z $days && $arg =~ ^[1-9][0-9]{0,3}$ ]] || usage
      days=$arg ;;
  esac
done
days=${days:-30}

manager=''
case "$action" in
  clean-all|clean-cache|clean-updates) manager=$(pkg_manager) ;;
esac

prepare_step() {
  local step=$1
  unavailable=''
  case "$step" in
    clean-cache|clean-updates)
      case "$manager:$step" in
        apt-get:clean-cache|dnf:clean-cache|yum:clean-cache)
          description='Remove downloaded packages from the package cache.'
          if [[ $manager == apt-get ]]; then
            description='Remove all downloaded packages from the APT cache, including obsolete downloads.'
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
        *) unavailable='Package cleanup requires apt-get, dnf, or yum.'; return 1 ;;
      esac ;;
    rotate-logs)
      description='Rotate logs and apply retention according to /etc/logrotate.conf.'
      operation=(logrotate /etc/logrotate.conf) ;;
    vacuum-journal)
      description="Remove archived system journal files older than $days days."
      operation=(journalctl --system "--vacuum-time=${days}days") ;;
    clean-temp)
      description='Clean expired files under /tmp and /var/tmp according to system tmpfiles.d rules.'
      operation=(systemd-tmpfiles --clean --prefix=/tmp --prefix=/var/tmp) ;;
  esac
}

check_step() {
  if ! command -v "${operation[0]}" >/dev/null 2>&1; then
    unavailable="Required command not found: ${operation[0]}"
    return 1
  fi
  if [[ $1 == rotate-logs && ! -r /etc/logrotate.conf ]]; then
    unavailable='Cannot read /etc/logrotate.conf.'
    return 1
  fi
}

case "$action" in
  clean-all)
    steps=(clean-cache clean-updates rotate-logs vacuum-journal clean-temp)
    if [[ $manager == apt-get ]]; then
      steps=(clean-cache rotate-logs vacuum-journal clean-temp)
    fi
    section 'CLEANUP PLAN'
    info 'This plan covers package caches, log retention and expired temporary files.'
    info 'Installed packages and kernels are kept.' ;;
  clean-cache|clean-updates|rotate-logs|vacuum-journal|clean-temp) steps=("$action") ;;
  *) usage ;;
esac

ready=()
skipped=0
for step in "${steps[@]}"; do
  if ! prepare_step "$step" || ! check_step "$step"; then
    if [[ $action != clean-all ]]; then error "$unavailable"; exit 1; fi
    warn "Skipping $step. $unavailable"
    ((skipped += 1))
    continue
  fi
  ready+=("$step")
  info "$description"
  printf 'Command:'
  printf ' %q' "${operation[@]}"
  printf '\n'
done

if (( ${#ready[@]} == 0 )); then
  error 'No cleanup operations are available.'
  exit 1
fi

if [[ $mode == --dry-run ]]; then
  info 'Preview only. No cleanup operations were run.'
  exit 0
fi

require_root
if [[ $mode == confirm ]]; then
  if [[ ! -t 0 ]]; then
    error 'Use an interactive terminal to confirm, or pass --yes to run unattended.'
    exit 1
  fi
  if ! yes_no "Run the ${#ready[@]} planned cleanup operation(s)?"; then
    info 'Cancelled.'
    exit 0
  fi
fi

completed=0
failed=0
result=0
for step in "${ready[@]}"; do
  prepare_step "$step"
  if [[ $action == clean-all ]]; then section "$step"; fi
  log_event INFO "maintenance.$step.started"
  if "${operation[@]}"; then
    log_event INFO "maintenance.$step.completed"
    ok 'Operation completed.'
    ((completed += 1))
  else
    status=$?
    log_event WARN "maintenance.$step.failed exit=$status"
    error "$step failed (exit $status). Review the command output before retrying."
    if [[ $action != clean-all ]] || (( status == 130 || status == 143 )); then exit "$status"; fi
    ((failed += 1))
    result=1
  fi
done

if [[ $action == clean-all ]]; then
  printf '\nCleanup results: %d completed, %d failed, %d skipped.\n' "$completed" "$failed" "$skipped"
fi
exit "$result"
