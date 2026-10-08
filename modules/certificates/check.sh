#!/usr/bin/env bash
set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"; source "$JFSTACK_ROOT/lib/core.sh"
require_command openssl
target="${1:-}"
[[ -n "$target" ]] || read -r -p 'Host[:port]: ' target
host="${target%%:*}"; port="${target##*:}"; [[ "$target" == "$host" ]] && port=443
banner; section "TLS CERTIFICATE: $host:$port"
cert="$(mktemp)"; trap 'rm -f "$cert"' EXIT
if ! timeout 10 openssl s_client -servername "$host" -connect "$host:$port" </dev/null 2>/dev/null | openssl x509 -outform PEM >"$cert"; then error 'Could not retrieve certificate.'; exit 1; fi
openssl x509 -in "$cert" -noout -subject -issuer -serial -dates -fingerprint -sha256
end="$(openssl x509 -in "$cert" -noout -enddate | cut -d= -f2)"
if exp_epoch="$(date -d "$end" +%s 2>/dev/null)"; then now="$(date +%s)"; printf 'daysRemaining=%s\n' "$(( (exp_epoch-now)/86400 ))"; fi
