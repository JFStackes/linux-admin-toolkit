#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

printf '== Bash syntax ==\n'
while IFS= read -r -d '' file; do
  bash -n "$file"
done < <(find "$ROOT" -type f -name '*.sh' -print0)
bash -n "$ROOT/bin/jfstack-admin"

printf '== CLI ==\n'
"$ROOT/bin/jfstack-admin" --version
"$ROOT/bin/jfstack-admin" --help >/dev/null
"$ROOT/bin/jfstack-admin" system info >/dev/null

printf '== Branding / secret-log guard ==\n'
grep -q 'JFStack Linux Admin Toolkit' "$ROOT/README.md"
if grep -RniE 'log_event.*(password=|private_key=|token=|secret=)' "$ROOT"/modules "$ROOT"/lib; then
  printf 'Potential secret logging detected.\n' >&2
  exit 1
fi

printf 'Smoke tests passed.\n'
