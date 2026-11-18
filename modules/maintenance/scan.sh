#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
# shellcheck source=lib/core.sh
source "$JFSTACK_ROOT/lib/core.sh"

action=${1:-}
directory=${2-/}
limit=${3-10}
if [[ $# -gt 3 || ! $limit =~ ^([1-9][0-9]?|100)$ ]]; then
  error 'Use: maintenance large-dirs|large-files [PATH] [LIMIT (1-100)]'
  exit 2
fi

case "$action" in
  large-dirs)
    require_command du
    heading='Largest immediate subdirectories by disk usage' ;;
  large-files)
    require_command find
    heading='Largest regular files by apparent size' ;;
  *) error 'Choose large-dirs or large-files.'; exit 2 ;;
esac
require_command sort
require_command sed
require_command numfmt

if [[ -z $directory ]]; then
  error 'Scan path must be a directory.'
  exit 2
fi
if [[ $directory != /* ]]; then directory="./$directory"; fi
if ! cd -P -- "$directory"; then exit 1; fi

scan_entries() {
  if [[ $action == large-dirs ]]; then
    du -x -d 1 -B 1 -0 . | while IFS= read -r -d '' entry; do
      # du includes the total of the requested directory as well as its children.
      if [[ ${entry#*$'\t'} != . ]]; then printf '%s\0' "$entry"; fi
    done
  else
    find . -xdev -type f -printf '%s\t%p\0'
  fi
}

section "$heading"
printf 'Directory: %q\n' "$PWD"
if ! scan_entries | LC_ALL=C sort -z -t $'\t' -k 1,1nr | sed -z -n "1,${limit}p" |
  while IFS= read -r -d '' entry; do
    size=$(numfmt --to=iec-i --suffix=B "${entry%%$'\t'*}") || exit 1
    printf '%10s  %q\n' "$size" "${entry#*$'\t'}"
  done; then
  warn 'Scan did not complete successfully. Results may be incomplete.'
  exit 1
fi
