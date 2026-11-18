#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cli="$ROOT/bin/jfstack-admin"
fixture=$(mktemp -d)
trap 'rm -rf -- "${fixture:?}"' EXIT

scan="$fixture/scan root"
mkdir -p "$scan/a large directory" "$scan/small" "$fixture/path"
large_file=$'./a large directory/line\nbreak'
dd if=/dev/zero of="$scan/$large_file" bs=4096 count=16 status=none
truncate -s 1 "$scan/small/small-file"
ln -s "$fixture" "$scan/a large directory/outside-scan"

results=$("$cli" maintenance large-files "$scan" 1)
[[ $results == *"$(printf '%q' "$large_file")"* && $results != *small-file* ]]
results=$("$cli" maintenance large-dirs "$scan" 1)
[[ $results == *'./a\ large\ directory'* && $results != *'./small'* ]]

results=$(printf '16\n4\n%s\n1\n\n0\n0\n' "$scan" | TERM=dumb "$cli")
[[ $results == *'16) Analysis & Cleanup'* && $results == *"$(printf '%q' "$large_file")"* ]]
[[ $(grep -c ' ANALYSIS & CLEANUP' <<< "$results") -eq 2 ]]

# Make the preview checks distro-independent and ensure they never run a system command.
for program in bash dirname cat; do
  ln -s "$(command -v "$program")" "$fixture/path/$program"
done
cat > "$fixture/backend" <<'STUB'
#!/usr/bin/env bash
printf 'Maintenance unexpectedly invoked a backend.\n' >&2
exit 99
STUB
chmod +x "$fixture/backend"
for program in journalctl systemd-tmpfiles; do
  ln -s "$fixture/backend" "$fixture/path/$program"
done

for manager in apt-get dnf yum; do
  ln -s "$fixture/backend" "$fixture/path/$manager"
  cache='clean packages'
  updates='clean metadata'
  if [[ $manager == apt-get ]]; then
    cache=clean
    updates=autoclean
  fi
  results=$(PATH="$fixture/path" "$cli" maintenance clean-cache --dry-run)
  [[ $results == *"Command: $manager $cache"* ]]
  results=$(PATH="$fixture/path" "$cli" maintenance clean-updates --dry-run)
  [[ $results == *"Command: $manager $updates"* ]]
  rm -- "$fixture/path/$manager"
done

results=$(PATH="$fixture/path" "$cli" maintenance vacuum-journal --dry-run)
[[ $results == *'--vacuum-time=30days'* ]]
results=$(PATH="$fixture/path" "$cli" maintenance vacuum-journal 45 --dry-run)
[[ $results == *'--vacuum-time=45days'* ]]
results=$(PATH="$fixture/path" "$cli" maintenance clean-temp --dry-run)
[[ $results == *'systemd-tmpfiles --clean --prefix=/tmp --prefix=/var/tmp'* ]]

status=0
PATH="$fixture/path" "$cli" maintenance vacuum-journal 0 --yes >/dev/null 2>&1 || status=$?
[[ $status -eq 2 ]]
status=0
PATH="$fixture/path" "$cli" maintenance vacuum-journal --yes --dry-run >/dev/null 2>&1 || status=$?
[[ $status -eq 2 ]]
status=0
printf 'y\n' | PATH="$fixture/path" "$cli" maintenance vacuum-journal >/dev/null 2>&1 || status=$?
[[ $status -eq 1 ]]
