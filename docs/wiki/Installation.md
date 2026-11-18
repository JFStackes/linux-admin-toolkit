# Installation

## Run from a clone

```bash
git clone git@github.com:JFStackes/linux-admin-toolkit.git
cd linux-admin-toolkit
./bin/jfstack-admin
```

## System-wide installation

```bash
sudo ./install.sh
jfstack-admin --version
jfstack-admin
```

This installs project files in `/opt/jfstack-admin` and creates the `/usr/local/bin/jfstack-admin` link. Run `sudo ./install.sh` again from an updated checkout to replace the installed program files. The changelog is installed at `docs/CHANGELOG.md` under `/opt/jfstack-admin` and is also available through the previous `CHANGELOG.md` path.

## Uninstall

Run `sudo ./uninstall.sh` from a checkout and confirm the removal. Toolkit logs and generated keys are retained. Reports stored outside the installation directory are also retained.

## Dependencies

Core user administration expects standard account tools (`useradd`, `usermod`, `chpasswd`, `chage`). Generating new SSH key pairs additionally requires `ssh-keygen` from the OpenSSH client package. The toolkit validates this before creating the account so a missing dependency does not leave a partially configured user.

Read-only commands run with the caller's permissions. Use `sudo` for user administration and cleanup. See [[Maintenance]] for the dependencies of each maintenance action.
