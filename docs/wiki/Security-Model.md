# Security Model

## Principles

- Least privilege where practical.
- No password, private-key content, token or secret logging.
- Explicit confirmation for destructive operations.
- Generated diagnostic reports use restrictive permissions.
- Generated private keys are stored outside user home directories by default and with mode `0600`.
- The toolkit does not modify unrelated system configuration only to add JFStack branding.

## Docker group

Membership in the Docker group is highly privileged and can provide effective root-level control over a host. The toolkit never enables Docker membership by default.

## Generated SSH keys

When `--generate-ssh-key` is used, the public key is installed into the target account. The private key remains in a root-only JFStack state directory until the administrator transfers and removes it.

## Logs

Root operations are logged to `/var/log/jfstack-admin/jfstack-admin.log`. Only operational metadata is recorded.
