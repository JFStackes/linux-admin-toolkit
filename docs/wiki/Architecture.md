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
