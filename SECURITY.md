# Security Policy

JFStack Linux Admin Toolkit performs privileged system-administration operations. Security reports are welcome.

## Reporting a vulnerability

Do not publish credentials, private keys, tokens, host inventories, IP addresses or other sensitive infrastructure data in a public issue.

For a security-sensitive report, use a private security reporting mechanism provided by the GitHub repository when available.

## Security expectations

- Secrets must never be written to toolkit logs.
- New mutating operations must validate prerequisites before changing the system.
- Partial failures should be rolled back where doing so is safe and deterministic.
- Destructive operations require explicit confirmation or a clearly documented non-interactive override.
- Generated files containing operational metadata should use restrictive permissions by default.
