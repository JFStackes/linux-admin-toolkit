#!/usr/bin/env bash
# JFStack Linux Admin Toolkit - platform helpers

os_pretty_name() {
  if [[ -r /etc/os-release ]]; then
    . /etc/os-release
    printf '%s\n' "${PRETTY_NAME:-${NAME:-Linux}}"
  else
    uname -s
  fi
}

primary_ip() {
  local ip
  ip="$(hostname -I 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i !~ /^127\./ && $i !~ /:/){print $i; exit}}')"
  [[ -n "$ip" ]] || ip="$(ip -4 route get 1.1.1.1 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="src"){print $(i+1); exit}}')"
  printf '%s\n' "${ip:-UNKNOWN}"
}

ssh_port() {
  local port=''
  if command -v sshd >/dev/null 2>&1; then
    port="$(sshd -T 2>/dev/null | awk '$1=="port" {print $2; exit}')"
  fi
  if [[ -z "$port" && -r /etc/ssh/sshd_config ]]; then
    port="$(awk 'BEGIN{IGNORECASE=1} /^[[:space:]]*Port[[:space:]]+/ {print $2; exit}' /etc/ssh/sshd_config)"
  fi
  printf '%s\n' "${port:-22}"
}

sudo_group() {
  if getent group sudo >/dev/null 2>&1; then printf 'sudo\n';
  elif getent group wheel >/dev/null 2>&1; then printf 'wheel\n';
  else printf '\n'; fi
}

pkg_manager() {
  for p in apt-get dnf yum zypper pacman; do command -v "$p" >/dev/null 2>&1 && { printf '%s\n' "$p"; return; }; done
  printf 'unknown\n'
}
