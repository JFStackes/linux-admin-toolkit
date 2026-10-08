# User Management

User management is the first mutating module in v0.1.

## Authentication modes

Interactive creation supports:

1. Generated password.
2. Existing SSH public key.
3. Generated Ed25519 key pair.
4. Generated password plus existing public key.
5. Generated password plus generated Ed25519 pair.
6. Locked password with no key, useful when preparing an account for later provisioning.

## Expiration

Supported values: `none`, `24h`, `1d`, `7d`, `1m`, `1y`, or an explicit `YYYY-MM-DD` date.

Linux account expiration is date-based. In v0.1, `24h` and `1d` map to the next calendar date rather than an exact 24-hour timer.

## Examples

```bash
sudo jfstack-admin user create takaka --expires 7d --docker --generate-password
```

```bash
sudo jfstack-admin user create adminops --expires none --sudo --public-key-file adminops.pub
```

```bash
sudo jfstack-admin user create vendor --expires 1m --generate-ssh-key
```
