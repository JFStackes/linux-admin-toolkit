# JFStack Linux Admin Toolkit documentation

## Operate the toolkit

- [English quick start](../README.md) and [Spanish quick start](README.es.md)
- [Install, update and uninstall](wiki/Installation.md)
- [CLI reference](wiki/CLI-Reference.md)
- [Analyze disk usage and clean a host](wiki/Maintenance.md)
- [Manage users](wiki/User-Management.md), [`user create` options](commands/user-create.md) and a [temporary contractor example](examples/temporary-contractor.md)
- [Troubleshoot](wiki/Troubleshooting.md) and [review the security model](wiki/Security-Model.md)

## Maintain the project

- [Architecture](wiki/Architecture.md)
- [Changelog](CHANGELOG.md) and [roadmap](wiki/Roadmap.md)
- [Contribution and validation guide](CONTRIBUTING.md)
- [Security policy](SECURITY.md)

## Publish the wiki

The [GitHub Wiki source](wiki/Home.md) lives in `docs/wiki/`. After enabling the GitHub Wiki and creating its first page, publish from the repository root with `./scripts/publish-wiki.sh`. The script synchronizes the Markdown pages and pushes to `git@github.com:JFStackes/linux-admin-toolkit.wiki.git` by default. Set `WIKI_URL` to select a different Wiki remote.
