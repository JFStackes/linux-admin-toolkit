# Analysis and cleanup

Run `jfstack-admin` and choose **2) Analysis & Cleanup**. Use **5) Cleanup options** for cleanup or `0` to return to the main menu. Run `sudo jfstack-admin` to apply cleanup from the menu.

## Inspection

| Menu option | CLI | Result |
| --- | --- | --- |
| 1. Disk space, inodes and block devices | `jfstack-admin storage info` | Filesystem and inode utilization, plus block devices when `lsblk` is available |
| 2. Find the largest directories | `jfstack-admin maintenance large-dirs [PATH] [LIMIT]` | Immediate subdirectories ranked by disk blocks used, including their contents |
| 3. Find the largest files | `jfstack-admin maintenance large-files [PATH] [LIMIT]` | Regular files ranked recursively by logical size, including sparse regions |
| 4. Show system journal disk usage | `jfstack-admin maintenance journal-usage` | Space used by the system journal |

Scans default to `/` and 10 results. Set `LIMIT` to an integer from 1 to 100. Each scan stays on the selected filesystem and does not follow symbolic links it encounters during traversal. To inspect a separate filesystem, scan its mount point. Output paths are relative to the displayed directory and use Bash escaping for special characters. A traversal error can leave partial results and returns a nonzero exit status.

## Cleanup

| Menu option | CLI action after `jfstack-admin maintenance` | Scope and dependency |
| --- | --- | --- |
| 1. Clean all available items | `clean-all [DAYS]` | Previews the available operations below and applies the plan after a single confirmation. |
| 2. Package cache | `clean-cache` | Removes downloaded package files using `apt-get clean`, `dnf clean packages` or `yum clean packages`. |
| 3. Update leftovers | `clean-updates` | Runs `apt-get autoclean` for obsolete package downloads, or `dnf clean metadata` / `yum clean metadata` for cached repository metadata. The RPM package manager downloads fresh metadata when needed. |
| 4. Log rotation | `rotate-logs` | Runs `logrotate /etc/logrotate.conf` and applies the configured rotation and retention rules as they become due. |
| 5. Old journal archives | `vacuum-journal [DAYS]` | Uses `journalctl` to remove archived system journal files older than `DAYS`. The default is 30 days and the accepted range is 1–9999. The active journal stays available. |
| 6. Expired temporary files | `clean-temp` | Uses `systemd-tmpfiles --clean` with the system's age-based rules for `/tmp` and `/var/tmp`. |

Package cleanup applies to cached files. Installed packages and kernels stay in place. The system utilities define the detailed behavior. [APT](https://manpages.debian.org/bookworm/apt/apt-get.8.en.html), [DNF](https://dnf.readthedocs.io/en/latest/command_ref.html#clean-command), [logrotate](https://github.com/logrotate/logrotate/blob/main/logrotate.8.in), [journalctl](https://www.freedesktop.org/software/systemd/man/latest/journalctl.html), [systemd-tmpfiles](https://www.freedesktop.org/software/systemd/man/latest/systemd-tmpfiles.html).

Cleanup requires root and confirmation from a terminal. Press Enter or answer `n` at the confirmation prompt to cancel. Use `--dry-run` to view the planned commands without root. Pass `--yes` to authorize unattended execution.

On APT systems, `clean-all` runs `apt-get clean` once because it already covers obsolete downloads. The plan lists steps that are unavailable. After execution, the summary gives counts of completed, failed and skipped steps. Independent steps continue after a failure. The batch returns a nonzero status if a step fails or if no cleanup operations are available. An individual action returns an error when its required utility or configuration is missing.

```bash
jfstack-admin maintenance large-dirs /var 10
jfstack-admin maintenance large-files /home 20
jfstack-admin maintenance clean-all 45 --dry-run
sudo jfstack-admin maintenance clean-all 45
sudo jfstack-admin maintenance rotate-logs --yes
```

When a cleanup starts, the toolkit records the action and its outcome in `/var/log/jfstack-admin/jfstack-admin.log`. If a system utility returns an error, review its output before retrying because it may already have applied some changes.
