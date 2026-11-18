# Analysis and cleanup

Run `jfstack-admin` and choose **16) Analysis & Cleanup**. The submenu keeps you in maintenance after each operation. Choose `0` to return to the main menu. Run `sudo jfstack-admin` for interactive cleanup.

## Inspection

| Menu option | CLI | Result |
| --- | --- | --- |
| 1. Maintenance overview | `jfstack-admin maintenance overview` | Filesystems at 80% capacity or higher, journal usage, failed services and reboot status |
| 2. Disk space and inode usage | `jfstack-admin storage info` | Filesystem and inode utilization, plus block devices when `lsblk` is available |
| 3. Largest subdirectories | `jfstack-admin maintenance large-dirs [PATH] [LIMIT]` | Immediate subdirectories ranked by disk blocks used, including their contents |
| 4. Largest files | `jfstack-admin maintenance large-files [PATH] [LIMIT]` | Regular files ranked recursively by logical size, including sparse regions |

Scans default to `/` and 10 results. Set `LIMIT` to an integer from 1 to 100. Each scan stays on the selected filesystem and does not follow symbolic links it encounters during traversal. To inspect a separate filesystem, scan its mount point. Output paths are relative to the displayed directory and use Bash escaping for special characters. A traversal error can leave partial results and returns a nonzero exit status.

## Cleanup

| Menu option | CLI action after `jfstack-admin maintenance` | Scope and dependency |
| --- | --- | --- |
| 5. Package cache | `clean-cache` | Removes downloaded package files using `apt-get clean`, `dnf clean packages` or `yum clean packages`. |
| 6. Update leftovers | `clean-updates` | Runs `apt-get autoclean` for obsolete package downloads, or `dnf clean metadata` / `yum clean metadata` for cached repository metadata. The RPM package manager downloads fresh metadata when needed. |
| 7. Log rotation | `rotate-logs` | Runs `logrotate /etc/logrotate.conf` and applies the configured rotation and retention rules as they become due. |
| 8. Old journal archives | `vacuum-journal [DAYS]` | Uses `journalctl` to remove archived system journal files older than `DAYS`. The default is 30 days and the accepted range is 1–9999. The active journal stays available. |
| 9. Expired temporary files | `clean-temp` | Uses `systemd-tmpfiles --clean` with the system's age-based rules for `/tmp` and `/var/tmp`. |

Package cleanup applies to cached files. Installed packages and kernels stay in place. The system utilities define the detailed behavior. [APT](https://manpages.debian.org/bookworm/apt/apt-get.8.en.html), [DNF](https://dnf.readthedocs.io/en/latest/command_ref.html#clean-command), [logrotate](https://github.com/logrotate/logrotate/blob/main/logrotate.8.in), [journalctl](https://www.freedesktop.org/software/systemd/man/latest/journalctl.html), [systemd-tmpfiles](https://www.freedesktop.org/software/systemd/man/latest/systemd-tmpfiles.html).

Cleanup requires root and confirmation from a terminal. Press Enter or answer `n` to cancel. To inspect the command and its scope without running it, pass `--dry-run`. The preview prints the command only and requires no privilege escalation. For unattended execution, pass `--yes` explicitly. If a required utility or configuration is unavailable, the action returns an error.

```bash
jfstack-admin maintenance large-dirs /var 10
jfstack-admin maintenance large-files /home 20
jfstack-admin maintenance vacuum-journal 45 --dry-run
sudo jfstack-admin maintenance vacuum-journal 45
sudo jfstack-admin maintenance rotate-logs --yes
```

When a cleanup starts, the toolkit records the action and its outcome in `/var/log/jfstack-admin/jfstack-admin.log`. If a system utility returns an error, review its output before retrying because it may already have applied some changes.
