#!/usr/bin/env bash
# JFStack Linux Admin Toolkit - output helpers

if [[ -t 1 ]]; then
  C_RESET='\033[0m'
  C_BOLD='\033[1m'
  C_GREEN='\033[32m'
  C_YELLOW='\033[33m'
  C_RED='\033[31m'
  C_CYAN='\033[36m'
else
  C_RESET=''; C_BOLD=''; C_GREEN=''; C_YELLOW=''; C_RED=''; C_CYAN=''
fi

line() { printf '%s\n' '============================================================'; }
subline() { printf '%s\n' '------------------------------------------------------------'; }

banner() {
  line
  printf ' %bJFSTACK LINUX ADMIN TOOLKIT%b\n' "$C_BOLD" "$C_RESET"
  line
}

info() { printf '%b[INFO]%b %s\n' "$C_CYAN" "$C_RESET" "$*"; }
ok() { printf '%b[OK]%b   %s\n' "$C_GREEN" "$C_RESET" "$*"; }
warn() { printf '%b[WARN]%b %s\n' "$C_YELLOW" "$C_RESET" "$*" >&2; }
error() { printf '%b[ERROR]%b %s\n' "$C_RED" "$C_RESET" "$*" >&2; }
section() { printf '\n'; subline; printf ' %s\n' "$*"; subline; }
