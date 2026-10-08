# Installation

## Run from a clone

```bash
git clone git@github.com:JFStackes/linux-admin-toolkit.git
cd linux-admin-toolkit
sudo ./bin/jfstack-admin
```

## System-wide installation

```bash
sudo ./install.sh
jfstack-admin --version
sudo jfstack-admin
```

This installs project files in `/opt/jfstack-admin` and creates `/usr/local/bin/jfstack-admin`.

## Dependencies

Core user administration expects standard account tools (`useradd`, `usermod`, `chpasswd`, `chage`). Generating new SSH key pairs additionally requires `ssh-keygen` from the OpenSSH client package. The toolkit validates this before creating the account so a missing dependency does not leave a partially configured user.
