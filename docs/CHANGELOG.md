# Changelog

## Unreleased

- Organized the main menu into six task categories, with storage analysis under **Analysis & Cleanup**, troubleshooting tests under **Diagnostics** and direct access to system, network and software status.
- Added a plan for cleaning all available items in one operation, with preview, explicit confirmation and a result summary. Individual cleanup commands remain available.
- Consolidated project documentation under `docs/` and added a Spanish quick start.

## 0.1.0 - 2026-09-30

Initial public version.

- Added `jfstack-admin` interactive menu and CLI dispatcher.
- Added user creation with optional expiration, sudo, Docker membership and secure password generation.
- Added SSH public-key import and Ed25519 key-pair generation.
- Added user information, expiration management, password reset and deletion.
- Added read-only operational modules for system, services, processes, storage, network, SSH, firewall, Docker, packages, logs, security, certificates, backups and diagnostics.
- Added JFStack operation logging without secret material.
- Added installer, smoke tests and initial wiki source.
