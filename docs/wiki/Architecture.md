# Architecture

The CLI is a thin dispatcher over independent administration modules.

```text
bin/jfstack-admin
       |
       +---- interactive menu
       |
       +---- CLI dispatcher
                 |
                 +---- modules/*
                         |
                         +---- lib/core.sh
                         +---- lib/platform.sh
                         +---- lib/validation.sh
                         +---- lib/logging.sh
                         +---- lib/output.sh
```

This keeps each task inspectable and allows a module to be executed directly during development or troubleshooting.

Menu option `16` and the `maintenance` CLI category share the same entry points. `modules/maintenance/overview.sh` reports disk pressure, journal usage, failed services and reboot status. `scan.sh` ranks files or directories. `cleanup.sh` validates arguments, selects the system utility, previews the command and requires confirmation before writing maintenance events and running it. Disk and inode usage comes from `modules/storage/overview.sh`.
