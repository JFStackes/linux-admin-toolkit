# Temporary contractor account

```bash
sudo jfstack-admin user create contractor \
  --expires 7d \
  --generate-ssh-key
```

Give the contractor the private key using a secure channel. When delivery has been confirmed, delete the server-side copy of that private key. The public key remains in the account's `authorized_keys` file.
