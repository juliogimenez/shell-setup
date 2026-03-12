# Shell-Setup Modernization SPEC

## Overview
Actualización del entorno de desarrollo 'shell-setup' para corregir inconsistencias técnicas, mejorar la robustez de la instalación en Windows/WSL y añadir soporte para Zsh.

## Requirements
- Soportar **Zsh** como alternativa principal a Bash.
- Automatizar la instalación de plugins esenciales (`zsh-autosuggestions`, `zsh-syntax-highlighting`).
- Corregir la inconsistencia de fuentes en `README.md` (**IosevkaTerm Nerd Font**).
- Eliminar el hardcodeo de la distribución `Ubuntu` en `alacritty.toml`.
- Mejorar el manejo de rutas con espacios en `install-windows.bat`.
- Instalar y configurar el **Modern Unix Stack**:
  - `eza` (reemplazo de `ls`).
  - `bat` (reemplazo de `cat`).
  - `ripgrep` (reemplazo de `grep`).
  - `fd-find` (reemplazo de `find`).
- Implementar un sistema de **Productivity Aliases** para estas herramientas.
- Integrar profundamente **FZF** con Zsh para búsqueda de historial y archivos.

## Functionality
- **Detección de Distro**: `install-windows.bat` dinámico.
- **Zsh Setup**: Configuración ligera de `.zshrc` con Starship, Zellij y plugins.
- **Modern Tools**: Instalación automatizada de herramientas Rust para la terminal.
- **Aliases**: Mapeo de comandos clásicos a sus versiones modernas (`ls` -> `eza`, etc.).

## Acceptance Criteria
- AC-001: `zsh` instalado y funcional con plugins de autosugerencia.
- AC-002: `README.md` recomienda la fuente correcta (Iosevka).
- AC-003: Alacritty abre la distro de WSL por defecto sin configuración manual de nombre.
- AC-004: `install-windows.bat` funciona en rutas con espacios (ej. "Juan Perez").

## Technical Notes
- No se usará 'Oh My Zsh' para mantener el sistema ligero.
- Los plugins se clonarán directamente en `~/.zsh/plugins`.
- Se mantendrá la compatibilidad con Bash como fallback.
