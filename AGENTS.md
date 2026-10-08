# AGENTS.md

## Project
JFStack Linux Admin Toolkit (`jfstack-admin`)

## Principles
- Bash-first, readable and auditable.
- Prefer standard Linux utilities over opaque abstractions.
- Never log passwords, private keys, tokens, or secrets.
- Destructive actions require explicit confirmation unless a non-interactive force flag is documented.
- Keep modules independently executable where practical.
- Detect platform capabilities instead of assuming a distribution.
- Keep JFStack branding professional and limited to tool-owned output, logs, reports, and generated files.

## Compatibility target
Initial target: Debian/Ubuntu and RHEL-family systems. Other distributions may work but are not guaranteed in v0.1.

## Validation
Before committing:
- `bash tests/smoke.sh`
- `shellcheck` all shell files when ShellCheck is available.
