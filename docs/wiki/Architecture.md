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

The main menu opens six task menus. Analysis, diagnostics, system, network and software dispatch through the same CLI commands available to scripts. Disk and inode usage comes from `modules/storage/overview.sh`. `modules/maintenance/scan.sh` ranks files or directories, and `cleanup.sh` builds and previews the cleanup plan before running each approved step. `modules/maintenance/overview.sh` also provides the legacy `maintenance overview` command.
