#!/usr/bin/env bash
# Publish docs/wiki/*.md to the GitHub Wiki repository.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WIKI_URL="${WIKI_URL:-git@github.com:JFStackes/linux-admin-toolkit.wiki.git}"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

git clone "$WIKI_URL" "$work/wiki"
find "$work/wiki" -maxdepth 1 -type f -name '*.md' -delete
cp "$ROOT"/docs/wiki/*.md "$work/wiki/"
cd "$work/wiki"
git add .
if git diff --cached --quiet; then
  printf 'Wiki is already up to date.\n'
  exit 0
fi
git commit -m 'docs: update JFStack Linux Admin Toolkit wiki'
git push
