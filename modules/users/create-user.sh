#!/usr/bin/env bash
# JFStack Linux Admin Toolkit
# https://jfstack.es
# Create Linux users with optional expiration, sudo/Docker groups and SSH authentication.

set -euo pipefail
JFSTACK_ROOT="${JFSTACK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
source "$JFSTACK_ROOT/lib/core.sh"

usage() {
  cat <<'USAGE'
Usage:
  create-user.sh USERNAME [options]

Options:
  --expires VALUE              none|24h|1d|7d|1m|1y|YYYY-MM-DD
  --sudo                       Add user to sudo/wheel group
  --docker                     Add user to docker group (must already exist)
  --generate-password          Generate a secure password and enable password login for the account
  --password VALUE             Set the supplied password (prefer interactive mode to avoid shell history)
  --public-key VALUE           Install an SSH public key
  --public-key-file PATH       Install SSH public key from file
  --generate-ssh-key           Generate an Ed25519 key pair and install the public key
  --key-output-dir PATH        Directory for generated key pair (default: /root/.jfstack-admin/keys/...)
  --shell PATH                 Login shell (default: /bin/bash)
  --help                       Show help

Examples:
  sudo jfstack-admin user create takaka --expires 7d --docker --generate-password
  sudo jfstack-admin user create tech --expires none --sudo --public-key-file ~/.ssh/id_ed25519.pub
  sudo jfstack-admin user create vendor --expires 1m --generate-ssh-key
USAGE
}

generate_password() {
  local random_hex
  if command -v openssl >/dev/null 2>&1; then
    random_hex="$(openssl rand -hex 16)"
  else
    random_hex="$(od -An -N16 -tx1 /dev/urandom | tr -d ' \n')"
  fi
  # 24 characters, high entropy, with explicit upper/lower/digit/special classes.
  printf 'J9!%s#\n' "${random_hex:0:20}"
}

resolve_expiration() {
  local value="$1"
  case "$value" in
    none|never|'') printf '\n' ;;
    24h|1d) date -d '+1 day' +%F ;;
    7d) date -d '+7 days' +%F ;;
    1m) date -d '+1 month' +%F ;;
    1y) date -d '+1 year' +%F ;;
    ????-??-??)
      date -d "$value" +%F >/dev/null 2>&1 || { error "Invalid expiration date: $value"; exit 2; }
      printf '%s\n' "$value"
      ;;
    *) error "Unsupported expiration value: $value"; exit 2 ;;
  esac
}

install_public_key() {
  local user="$1" key="$2" home group
  [[ "$key" =~ ^(ssh-(ed25519|rsa)|ecdsa-sha2-nistp(256|384|521))[[:space:]] ]] || warn "The supplied key does not begin with a commonly recognized SSH public-key prefix."
  home="$(getent passwd "$user" | cut -d: -f6)"
  group="$(id -gn "$user")"
  install -d -m 700 -o "$user" -g "$group" "$home/.ssh"
  touch "$home/.ssh/authorized_keys"
  chmod 600 "$home/.ssh/authorized_keys"
  chown "$user:$group" "$home/.ssh/authorized_keys"
  grep -Fxq "$key" "$home/.ssh/authorized_keys" 2>/dev/null || printf '%s\n' "$key" >> "$home/.ssh/authorized_keys"
  chown "$user:$group" "$home/.ssh/authorized_keys"
}

interactive() {
  local u expiry choice custom authmode
  banner
  section "CREATE USER"
  read -r -p "Username: " u
  valid_username "$u" || { error "Invalid username."; exit 2; }

  printf '\nExpiration:\n'
  printf '  1) 24 hours / 1 day\n  2) 7 days\n  3) 1 month\n  4) 1 year\n  5) No expiration\n  6) Custom date (YYYY-MM-DD)\n'
  read -r -p "Select [1-6]: " choice
  case "$choice" in
    1) expiry='1d' ;; 2) expiry='7d' ;; 3) expiry='1m' ;; 4) expiry='1y' ;; 5) expiry='none' ;;
    6) read -r -p "Expiration date: " custom; expiry="$custom" ;;
    *) error "Invalid selection."; exit 2 ;;
  esac

  INTERACTIVE_USER="$u"
  INTERACTIVE_EXPIRES="$expiry"
  INTERACTIVE_SUDO=false
  INTERACTIVE_DOCKER=false
  yes_no "Add to sudo/wheel?" N && INTERACTIVE_SUDO=true
  yes_no "Add to docker group?" N && INTERACTIVE_DOCKER=true

  printf '\nAuthentication:\n'
  printf '  1) Generated password\n  2) Existing SSH public key\n  3) Generate Ed25519 key pair\n  4) Generated password + existing SSH public key\n  5) Generated password + generated Ed25519 key pair\n  6) Locked password, no SSH key (administrative account preparation)\n'
  read -r -p "Select [1-6]: " authmode
  INTERACTIVE_GENERATE_PASSWORD=false
  INTERACTIVE_PUBLIC_KEY=''
  INTERACTIVE_GENERATE_KEY=false
  case "$authmode" in
    1) INTERACTIVE_GENERATE_PASSWORD=true ;;
    2) read -r -p "Paste SSH public key: " INTERACTIVE_PUBLIC_KEY ;;
    3) INTERACTIVE_GENERATE_KEY=true ;;
    4) INTERACTIVE_GENERATE_PASSWORD=true; read -r -p "Paste SSH public key: " INTERACTIVE_PUBLIC_KEY ;;
    5) INTERACTIVE_GENERATE_PASSWORD=true; INTERACTIVE_GENERATE_KEY=true ;;
    6) : ;;
    *) error "Invalid selection."; exit 2 ;;
  esac
}

main() {
  require_root
  require_command useradd
  require_command usermod
  require_command chpasswd

  local username='' expires='none' add_sudo=false add_docker=false gen_password=false password=''
  local public_key='' public_key_file='' gen_ssh_key=false key_output_dir='' login_shell='/bin/bash'

  if [[ $# -eq 0 ]]; then
    interactive
    username="$INTERACTIVE_USER"; expires="$INTERACTIVE_EXPIRES"; add_sudo="$INTERACTIVE_SUDO"; add_docker="$INTERACTIVE_DOCKER"
    gen_password="$INTERACTIVE_GENERATE_PASSWORD"; public_key="$INTERACTIVE_PUBLIC_KEY"; gen_ssh_key="$INTERACTIVE_GENERATE_KEY"
  else
    username="$1"; shift
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --expires) expires="${2:?Missing value for --expires}"; shift 2 ;;
        --sudo) add_sudo=true; shift ;;
        --docker) add_docker=true; shift ;;
        --generate-password) gen_password=true; shift ;;
        --password) password="${2:?Missing value for --password}"; shift 2 ;;
        --public-key) public_key="${2:?Missing value for --public-key}"; shift 2 ;;
        --public-key-file) public_key_file="${2:?Missing value for --public-key-file}"; shift 2 ;;
        --generate-ssh-key) gen_ssh_key=true; shift ;;
        --key-output-dir) key_output_dir="${2:?Missing value for --key-output-dir}"; shift 2 ;;
        --shell) login_shell="${2:?Missing value for --shell}"; shift 2 ;;
        --help|-h) usage; exit 0 ;;
        *) error "Unknown option: $1"; usage; exit 2 ;;
      esac
    done
  fi

  valid_username "$username" || { error "Invalid username: $username"; exit 2; }
  id "$username" >/dev/null 2>&1 && { error "User already exists: $username"; exit 3; }
  [[ -x "$login_shell" ]] || { error "Login shell is not executable: $login_shell"; exit 2; }

  # Validate all requested capabilities before changing the system.
  local expiration expiration_arg=() sudo_grp generated_password='' generated_private='' generated_public=''
  expiration="$(resolve_expiration "$expires")"
  [[ -n "$expiration" ]] && expiration_arg=(--expiredate "$expiration")
  if [[ -n "$public_key_file" ]]; then
    [[ -r "$public_key_file" ]] || { error "Cannot read public key file: $public_key_file"; exit 2; }
    public_key="$(<"$public_key_file")"
  fi
  if [[ "$gen_ssh_key" == true ]]; then
    require_command ssh-keygen
  fi
  if [[ "$add_sudo" == true ]]; then
    sudo_grp="$(sudo_group)"
    [[ -n "$sudo_grp" ]] || { error "No sudo/wheel group found; refusing to create a partially configured user."; exit 4; }
  fi
  if [[ "$add_docker" == true ]] && ! getent group docker >/dev/null 2>&1; then
    warn "Docker group does not exist; Docker membership will be skipped."
  fi

  local created_user=false
  rollback_user_on_error() {
    local rc=$?
    if [[ "$created_user" == true ]]; then
      warn "User creation failed after the account was created. Rolling back '$username'."
      userdel --remove "$username" >/dev/null 2>&1 || userdel "$username" >/dev/null 2>&1 || true
      log_event ERROR "user.create.rollback user=$username rc=$rc"
    fi
    exit "$rc"
  }
  trap rollback_user_on_error ERR

  useradd --create-home --shell "$login_shell" "${expiration_arg[@]}" "$username"
  created_user=true
  log_event INFO "user.create user=$username expiration=${expiration:-none}"

  if [[ "$add_sudo" == true ]]; then
    usermod -aG "$sudo_grp" "$username"
    log_event INFO "group.add user=$username group=$sudo_grp"
  fi

  if [[ "$add_docker" == true ]]; then
    if getent group docker >/dev/null 2>&1; then
      usermod -aG docker "$username"
      log_event INFO "group.add user=$username group=docker"
    else
      warn "Docker group does not exist; skipping Docker membership."
    fi
  fi

  if [[ "$gen_password" == true ]]; then
    generated_password="$(generate_password)"
    printf '%s:%s\n' "$username" "$generated_password" | chpasswd
    log_event INFO "password.set user=$username source=generated"
  elif [[ -n "$password" ]]; then
    warn "Supplying passwords on the command line may expose them in shell history or process inspection."
    printf '%s:%s\n' "$username" "$password" | chpasswd
    generated_password='(provided by operator)'
    log_event INFO "password.set user=$username source=provided"
  else
    passwd -l "$username" >/dev/null 2>&1 || true
    log_event INFO "password.lock user=$username"
  fi

  if [[ -n "$public_key" ]]; then
    install_public_key "$username" "$public_key"
    log_event INFO "ssh.authorized_key.add user=$username source=provided"
  fi

  if [[ "$gen_ssh_key" == true ]]; then
    require_command ssh-keygen
    if [[ -z "$key_output_dir" ]]; then
      key_output_dir="/root/.jfstack-admin/keys/${username}-$(date '+%Y%m%d-%H%M%S')"
    fi
    install -d -m 700 "$key_output_dir"
    generated_private="$key_output_dir/${username}_ed25519"
    generated_public="${generated_private}.pub"
    ssh-keygen -q -t ed25519 -a 64 -N '' -C "${username}@$(hostname)-jfstack-admin" -f "$generated_private"
    chmod 600 "$generated_private"
    chmod 644 "$generated_public"
    install_public_key "$username" "$(<"$generated_public")"
    log_event INFO "ssh.keypair.generate user=$username type=ed25519 private_path=$generated_private"
  fi

  local ip port groups auth_summary
  ip="$(primary_ip)"; port="$(ssh_port)"; groups="$(id -nG "$username")"
  if [[ "$gen_password" == true || -n "$password" ]]; then auth_summary='Password enabled'; else auth_summary='Password locked'; fi
  [[ -n "$public_key" || "$gen_ssh_key" == true ]] && auth_summary+=" + SSH key"

  printf '\n'; line
  printf ' JFSTACK | USER CREATED SUCCESSFULLY\n'
  line
  printf ' Username     : %s\n' "$username"
  if [[ "$gen_password" == true ]]; then printf ' Password     : %s\n' "$generated_password"; fi
  printf ' Expiration   : %s\n' "${expiration:-NONE}"
  printf ' Groups       : %s\n' "$groups"
  printf ' Authentication: %s\n' "$auth_summary"
  subline
  printf ' SSH          : ssh %s@%s -p %s\n' "$username" "$ip" "$port"
  if [[ -n "$generated_private" ]]; then
    subline
    printf ' Private key  : %s\n' "$generated_private"
    printf ' Public key   : %s\n' "$generated_public"
    printf ' SSH with key : ssh -i %s -p %s %s@%s\n' "$generated_private" "$port" "$username" "$ip"
    printf '\n IMPORTANT: Transfer the private key securely, then remove the server-side copy when no longer needed.\n'
  fi
  line
  log_event INFO "user.create.completed user=$username"
  created_user=false
  trap - ERR
}

main "$@"
