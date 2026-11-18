# JFStack Linux Admin Toolkit

[English README](../README.md) · [Índice de documentación](README.md) · [Historial de cambios](CHANGELOG.md)

`jfstack-admin` es una herramienta Bash para administrar, mantener y diagnosticar servidores Linux. Está orientada a Debian, Ubuntu y las distribuciones de la familia RHEL. Cada operación comprueba si las utilidades que necesita están disponibles en el equipo.

## Primeros pasos

Puedes abrir el menú desde el repositorio o instalar la herramienta para todo el equipo.

```bash
git clone git@github.com:JFStackes/linux-admin-toolkit.git
cd linux-admin-toolkit
./bin/jfstack-admin

sudo ./install.sh
jfstack-admin --help
```

El instalador copia la herramienta a `/opt/jfstack-admin` y crea el enlace `/usr/local/bin/jfstack-admin`. Consulta la [guía de instalación y desinstalación](wiki/Installation.md).

## Análisis y limpieza

Abre **16) Analysis & Cleanup** para consultar el espacio y los inodos, localizar los archivos y carpetas más grandes y revisar el estado de mantenimiento y el tamaño del journal. El submenú también permite limpiar la caché de paquetes, restos de actualizaciones, registros antiguos y archivos temporales, además de aplicar la rotación de logs del sistema.

```bash
jfstack-admin maintenance large-dirs /var 10
jfstack-admin maintenance large-files /home 20
jfstack-admin maintenance vacuum-journal 30 --dry-run
sudo jfstack-admin maintenance clean-cache
```

La limpieza requiere privilegios de root y confirmación interactiva. `--dry-run` muestra el comando sin ejecutarlo y `--yes` autoriza explícitamente la ejecución desatendida. La [guía de mantenimiento](wiki/Maintenance.md) describe qué afecta cada acción.

## Administración y diagnóstico

La herramienta permite crear y gestionar usuarios locales con caducidad opcional, pertenencia a grupos sudo y Docker, contraseñas generadas y claves SSH. El menú también incluye servicios, procesos, discos, red, SSH, cortafuegos, Docker, actualizaciones, logs, seguridad, certificados TLS, copias de seguridad y diagnósticos.

```bash
sudo jfstack-admin user create contractor --expires 7d --generate-password
jfstack-admin service status nginx
jfstack-admin network ports
sudo jfstack-admin diagnose /root/server-report.txt
```

Las operaciones como root se registran en `/var/log/jfstack-admin/jfstack-admin.log`. Las contraseñas, el contenido de las claves privadas y los tokens quedan fuera del registro. Consulta la [guía de usuarios](wiki/User-Management.md), la [referencia de CLI](wiki/CLI-Reference.md) y el [modelo de seguridad](wiki/Security-Model.md).

## Estructura del repositorio

| Ruta | Contenido |
| --- | --- |
| `bin/` | Menú y punto de entrada de la CLI |
| `lib/` | Funciones Bash compartidas |
| `modules/` | Operaciones de administración por categoría |
| `docs/` | Guías, fuentes de la wiki, historial y políticas |
| `scripts/` | Mantenimiento del repositorio y publicación de la wiki |
| `tests/` | Pruebas de humo |
| `.github/` | Flujo de integración continua |
| `install.sh`, `uninstall.sh` | Instalación y desinstalación en el sistema |

Ejecuta `bash tests/smoke.sh` antes de hacer un commit. La [guía de contribución](CONTRIBUTING.md) explica cómo ejecutar ShellCheck. Consulta la [política de seguridad](SECURITY.md) para comunicar vulnerabilidades.

Distribuido bajo la [licencia MIT](../LICENSE). [JFStack](https://jfstack.es)
