# JFStack Linux Admin Toolkit

**JFStack Linux Admin Toolkit** is a modular Bash toolkit for day-to-day Linux server administration, maintenance, diagnostics and troubleshooting.

The executable is intentionally short and memorable:

```bash
jfstack-admin
```

Project: **JFStack**  
Website: **https://jfstack.es**  
GitHub organization: **JFStackes**

## Current release

`v0.1.0` is the first usable release. Mutating operations are deliberately concentrated around user administration; most other modules begin as read-only inspection and diagnostic tools so the toolkit can be tested safely on real servers.

## Features

- Interactive administration menu with 16 categories.
- CLI mode for scripting and automation.
- Temporary or permanent local users.
- Account expiration: 1 day, 7 days, 1 month, 1 year, custom date, or no expiration.
- Optional sudo/wheel and Docker group membership.
- Secure generated passwords.
- Existing SSH public-key installation.
- Ed25519 key-pair generation and automatic `authorized_keys` configuration.
- System, service, process, disk, network, SSH, firewall, Docker and package inspection.
- Log and basic security overview.
- TLS certificate inspection.
- Backup-path inspection.
- Portable diagnostic reports.
- Tool-owned operational logging without secrets.

## Quick start

Run directly from the repository:

```bash
git clone git@github.com:JFStackes/linux-admin-toolkit.git
cd linux-admin-toolkit
sudo ./bin/jfstack-admin
```

Or install it:

```bash
sudo ./install.sh
sudo jfstack-admin
```

## Example: temporary user with password

```bash
sudo jfstack-admin user create takaka \
  --expires 7d \
  --docker \
  --generate-password
```

The final output includes the username, generated password, expiration, groups and an SSH connection command. Passwords are displayed to the operator but are never written to the toolkit log.

## Example: permanent SSH-key user

Use an existing public key:

```bash
sudo jfstack-admin user create adminops \
  --expires none \
  --sudo \
  --public-key-file /tmp/adminops.pub
```

Generate a new Ed25519 pair:

```bash
sudo jfstack-admin user create vendor \
  --expires 1m \
  --generate-ssh-key
```

The generated private key is stored below `/root/.jfstack-admin/keys/` with restrictive permissions. Transfer it using a secure channel and remove the server-side copy when it is no longer required.

> **Expiration note:** standard Linux account expiration via `chage`/`useradd` is date-based. In v0.1, `24h` and `1d` resolve to the next calendar date; they are not an exact-to-the-second 24-hour timer.

## CLI examples

```bash
jfstack-admin system info
jfstack-admin service status nginx
jfstack-admin process top mem
jfstack-admin storage info
jfstack-admin network ports
jfstack-admin ssh info
jfstack-admin firewall status
jfstack-admin docker status
jfstack-admin packages updates
jfstack-admin logs errors
jfstack-admin security overview
jfstack-admin cert check jfstack.es:443
jfstack-admin backup check /srv/backups
sudo jfstack-admin diagnose /root/server-report.txt
```

## Operational logging

Tool operations are recorded as JFStack-owned events:

```text
2026-09-30 23:50:02+0200 [INFO] user.create user=takaka expiration=2026-10-07
2026-09-30 23:50:02+0200 [INFO] group.add user=takaka group=docker
2026-09-30 23:50:03+0200 [INFO] user.create.completed user=takaka
```

Root executions use:

```text
/var/log/jfstack-admin/jfstack-admin.log
```

Passwords, private-key contents and tokens must never be logged.

## Repository structure

```text
linux-admin-toolkit/
├── bin/                  # jfstack-admin dispatcher
├── lib/                  # shared Bash libraries
├── modules/              # administration modules
├── docs/                 # command docs, examples and wiki source
├── scripts/              # project maintenance helpers
├── tests/                # smoke/static tests
├── AGENTS.md
├── CHANGELOG.md
├── LICENSE
├── README.md
└── VERSION
```

## Wiki

The initial GitHub Wiki source is in [`docs/wiki/`](docs/wiki/). GitHub Wikis are separate Git repositories, so placing a `wiki/` directory in the main repository does **not** populate the Wiki tab automatically.

After enabling the Wiki in GitHub and creating its first page, publish these pages with:

```bash
./scripts/publish-wiki.sh
```

The default target is:

```text
git@github.com:JFStackes/linux-admin-toolkit.wiki.git
```

## Security model

- No secrets in toolkit logs.
- Generated private keys are root-readable only.
- Destructive user deletion requires confirmation unless `--yes` is supplied.
- Existing configuration files are not branded or modified just to advertise JFStack.
- Docker group access is optional and should be treated as highly privileged access.
- Diagnostic reports are created mode `0600` because they can contain operational metadata.

See the Wiki source for the full security model and architecture.

## Compatibility

Initial focus:

- Debian / Ubuntu
- RHEL-family distributions (Rocky Linux, AlmaLinux, RHEL)

Some read-only modules can work on additional distributions. v0.1 does not claim full cross-distribution coverage yet.

## Development validation

```bash
bash tests/smoke.sh
```

If ShellCheck is installed:

```bash
find . -type f -name '*.sh' -print0 | xargs -0 shellcheck
shellcheck bin/jfstack-admin
```

## License

MIT License. See [`LICENSE`](LICENSE).
