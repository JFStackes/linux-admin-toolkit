# CLI Reference

```text
jfstack-admin user create ...
jfstack-admin user info USER
jfstack-admin user expire USER VALUE
jfstack-admin user password USER
jfstack-admin user delete USER [--remove-home] [--yes]
jfstack-admin system info
jfstack-admin service status [SERVICE]
jfstack-admin process top [cpu|mem]
jfstack-admin storage info
jfstack-admin network info
jfstack-admin network ports
jfstack-admin network test [TARGET]
jfstack-admin ssh info
jfstack-admin ssh sessions
jfstack-admin firewall status
jfstack-admin docker status
jfstack-admin packages updates
jfstack-admin logs errors
jfstack-admin security overview
jfstack-admin cert check HOST[:PORT]
jfstack-admin backup check PATH
jfstack-admin diagnose [OUTPUT_FILE]
jfstack-admin maintenance overview
jfstack-admin maintenance large-dirs [PATH] [LIMIT]
jfstack-admin maintenance large-files [PATH] [LIMIT]
jfstack-admin maintenance clean-cache [--dry-run|--yes]
jfstack-admin maintenance clean-updates [--dry-run|--yes]
jfstack-admin maintenance rotate-logs [--dry-run|--yes]
jfstack-admin maintenance vacuum-journal [DAYS] [--dry-run|--yes]
jfstack-admin maintenance clean-temp [--dry-run|--yes]
```

See [[Maintenance]] for defaults, requirements and the scope of each cleanup action.
