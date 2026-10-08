#!/usr/bin/env bash
# JFStack Linux Admin Toolkit installer
set -euo pipefail
[[ ${EUID:-$(id -u)} -eq 0 ]] || { echo '[ERROR] Run the installer with sudo/root.' >&2; exit 1; }
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST='/opt/jfstack-admin'
BIN='/usr/local/bin/jfstack-admin'
mkdir -p "$DEST"
for item in bin lib modules docs VERSION LICENSE CHANGELOG.md; do
  rm -rf "$DEST/$item"
  cp -a "$SRC/$item" "$DEST/$item"
done
chmod -R go-w "$DEST"
find "$DEST/bin" "$DEST/modules" -type f -name '*.sh' -exec chmod 755 {} + 2>/dev/null || true
chmod 755 "$DEST/bin/jfstack-admin"
ln -sfn "$DEST/bin/jfstack-admin" "$BIN"
printf 'JFStack Linux Admin Toolkit installed.\nCommand: %s\n' "$BIN"
"$BIN" --version
