# Contributing

Contributions to JFStack Linux Admin Toolkit should keep the project simple, auditable and useful to Linux administrators.

## Before submitting

```bash
bash tests/smoke.sh
find . -type f -name '*.sh' -print0 | xargs -0 shellcheck
shellcheck bin/jfstack-admin
```

## Guidelines

- Use Bash for toolkit modules unless there is a strong technical reason not to.
- Prefer standard Linux utilities and capability detection.
- Do not log secrets.
- Avoid changing system configuration as a branding mechanism.
- Document destructive behavior and require confirmation.
- Add or update Wiki source when a public CLI command changes.
