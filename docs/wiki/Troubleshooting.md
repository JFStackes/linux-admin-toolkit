# Troubleshooting

## Toolkit cannot detect the SSH port

The toolkit first tries `sshd -T`, then `/etc/ssh/sshd_config`, and finally falls back to port `22`. Include files and unusual daemon setups may require future detection improvements.

## Docker group does not exist

`--docker` only adds membership if the group already exists. The toolkit does not create a Docker group or install Docker as a side effect of user creation.

## Diagnostic reports

Before sharing a generated report, review it. Reports may contain hostnames, addresses, usernames, service names and other infrastructure metadata.
