# JFStack Linux Admin Toolkit

[Guía en español](docs/README.es.md) · [Documentation](docs/README.md) · [Changelog](docs/CHANGELOG.md)

`jfstack-admin` is a Bash toolkit for administering, maintaining and troubleshooting Linux servers. Its initial platform targets are Debian, Ubuntu and RHEL-family distributions. Commands check for the tools they need on the host.

## Quick start

Run the menu from a clone or install the toolkit system-wide.

```bash
git clone git@github.com:JFStackes/linux-admin-toolkit.git
cd linux-admin-toolkit
./bin/jfstack-admin

sudo ./install.sh
jfstack-admin --help
```

Installation copies the toolkit to `/opt/jfstack-admin` and links the executable from `/usr/local/bin/jfstack-admin`. See [installation and removal](docs/wiki/Installation.md).

## Analyze and clean a host

Open **16) Analysis & Cleanup** to inspect disk space, inode usage, the largest directories and files, journal usage and maintenance status. The same submenu offers package cache cleanup, update leftovers, policy-based log rotation, archived journal cleanup and expired temporary files.

```bash
jfstack-admin maintenance large-dirs /var 10
jfstack-admin maintenance large-files /home 20
jfstack-admin maintenance vacuum-journal 30 --dry-run
sudo jfstack-admin maintenance clean-cache
```

Cleanup requires root and an interactive confirmation. `--dry-run` shows the command without running it. `--yes` explicitly authorizes unattended execution. See the [maintenance guide](docs/wiki/Maintenance.md) for the scope of each action.

## Administer users and inspect a server

The toolkit supports local user lifecycle management with optional account expiration, sudo and Docker membership, generated passwords and SSH keys. The other menu categories cover services, processes, storage, networking, SSH, firewalls, Docker, updates, logs, security, TLS certificates, backups and diagnostics.

```bash
sudo jfstack-admin user create contractor --expires 7d --generate-password
jfstack-admin service status nginx
jfstack-admin network ports
sudo jfstack-admin diagnose /root/server-report.txt
```

Root operations are logged in `/var/log/jfstack-admin/jfstack-admin.log`. The toolkit keeps passwords, private-key contents and tokens out of its logs. See [user management](docs/wiki/User-Management.md), the [CLI reference](docs/wiki/CLI-Reference.md) and the [security model](docs/wiki/Security-Model.md).

## Repository layout

| Path | Contents |
| --- | --- |
| `bin/` | Menu and CLI dispatcher |
| `lib/` | Shared Bash helpers |
| `modules/` | Administration operations by category |
| `docs/` | Guides, wiki source, changelog and project policies |
| `scripts/` | Repository maintenance and wiki publishing |
| `tests/` | Smoke tests |
| `.github/` | CI workflow |
| `install.sh`, `uninstall.sh` | System-wide installation and removal |

Run `bash tests/smoke.sh` before committing. See the [contribution guide](docs/CONTRIBUTING.md) for ShellCheck instructions and the [security policy](docs/SECURITY.md) for vulnerability reporting.

Licensed under the [MIT License](LICENSE). [JFStack](https://jfstack.es)
