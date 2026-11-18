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

Open **2) Analysis & Cleanup** to check disk space, inodes, block devices and journal usage, or find the largest directories and files. Under **Cleanup options**, choose **Clean all available items** to review a single plan, or select an individual cleanup.

```bash
jfstack-admin maintenance large-dirs /var 10
jfstack-admin maintenance large-files /home 20
jfstack-admin maintenance clean-all 30 --dry-run
sudo jfstack-admin maintenance clean-all
```

Cleanup requires root and interactive confirmation. `--dry-run` shows the plan without applying it. `--yes` explicitly authorizes unattended execution. See the [maintenance guide](docs/wiki/Maintenance.md) for the scope of each action.

## Administer users and inspect a server

Use **1) Users & Groups** to manage local accounts, expiration, credentials and group membership. **3) Diagnostics** brings together recent errors, failed services, connectivity, TLS and backup checks, and the diagnostic report. Open **4) System & Services** for system and process details, **5) Network & Security** for network and access settings, or **6) Software & Containers** for updates and Docker.

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
