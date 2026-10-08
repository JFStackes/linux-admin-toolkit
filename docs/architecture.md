# Architecture

`jfstack-admin` is a dispatcher. It does not contain the operational implementation of every task.

```text
jfstack-admin
    |
    +-- interactive menu
    |
    +-- CLI dispatcher
            |
            +-- modules/users
            +-- modules/system
            +-- modules/network
            +-- modules/docker
            +-- ...
                    |
                    +-- lib/output.sh
                    +-- lib/logging.sh
                    +-- lib/validation.sh
                    +-- lib/platform.sh
```

The design keeps modules easy to audit and allows direct execution during troubleshooting.
