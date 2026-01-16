# Shell Setup - Windows + WSL Development Environment

Un entorno de desarrollo optimizado para frontend y backend con Alacritty, Zellij, Starship y herramientas modernas.

## 📁 Estructura del Proyecto

```
shell-setup/
├── README.md              # Esta documentación
├── install-windows.bat    # Script de instalación para Windows
├── install-wsl.sh         # Script de instalación para WSL
├── alacritty.toml         # Configuración de Alacritty (Windows)
├── starship.toml          # Configuración de Starship (WSL)
├── zellij.kdl             # Configuración de Zellij (WSL)
└── layouts/               # Layouts específicos de Zellij
    ├── dev.kdl
    ├── git.kdl
    └── fullstack.kdl
```

## 🚀 Instalación

### Opción recomendada: Instalación completa (Windows + WSL)

```powershell
# Ejecutar como Administrador en Windows
cd shell-setup
.\install-windows.bat
```

Este script instala automáticamente:
- Configuración de WSL (Starship, Zellij, symlinks)
- Configuración de Windows (Alacritty)

### Opción alternativa: Instalación manual

#### WSL:
```bash
cd shell-setup
./install-wsl.sh
```

#### Windows:
```powershell
# Ejecutar como Administrador
cd shell-setup
.\install-windows.bat
```

### Dependencias adicionales

#### Windows:
```powershell
# Instalar Alacritty
winget install Alacritty.Alacritty

# Instalar JetBrains Mono Nerd Font
# Descargar desde: https://www.nerdfonts.com/font-downloads
```

#### WSL:
```bash
# Instalar herramientas básicas
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget git neovim build-essential

# Nota: Starship y Zellij se instalan automáticamente por el script
```

## 🎯 Uso del Entorno

### Inicio Rápido
```bash
# Abrir terminal optimizado para frontend
zellij --layout dev

# Abrir terminal optimizado para git
zellij --layout git

# Abrir terminal para fullstack
zellij --layout fullstack

# Iniciar zellij sin layout específico
zellij
```

## ⚡ Comandos Principales

### Alacritty (Windows)
```powershell
# Aumentar/disminuir fuente
Ctrl + Plus/Minus
Ctrl + Shift + =/-

# Copiar/Pegar
Ctrl + Shift + C
Ctrl + Shift + V

# Pantalla completa
F11
```

### Zellij - Navegación y Paneles

#### Modo Normal
```bash
# Navegación entre paneles
Alt + h/j/k/l  # Izquierda/Abajo/Arriba/Derecha

# Navegación entre tabs
Ctrl + t       # Modo Tab
Alt + 1-9      # Ir a tab específica
Alt + h/l      # Tab anterior/siguiente

# Crear paneles
Alt + n        # Nuevo pane
Alt + c        # Cerrar pane actual
Alt + f        # Pantalla completa del pane actual
```

#### Modo Pane (Ctrl + p)
```bash
h/j/k/l        # Mover focus
n              # Nuevo pane y volver a modo normal
d              # Nuevo pane abajo
r              # Nuevo pane a la derecha
s              # Nuevo pane stacked
x              # Cerrar pane y volver a modo normal
f              # Toggle pantalla completa
c              # Renombrar pane
```

#### Modo Resize (Ctrl + n)
```bash
h/j/k/l        # Redimensionar (aumentar)
H/J/K/L        # Redimensionar (disminuir)
+/-            # Redimensionar en todos los sentidos
```

#### Modo Scroll (Ctrl + s)
```bash
j/k            # Scroll hacia abajo/arriba
Ctrl + f/b     # Page down/up
d/u            # Half page down/up
e              # Editar scrollback
s              # Buscar
q              # Salir al modo normal
```

### Starship - Prompt Personalizado

El prompt muestra:
- **Usuario @ Hostname**: `user@hostname`
- **Directorio actual**: `path/to/repo`
- **Rama Git**: `main`
- **Estado Git**: `*+?` (modificado, staged, untracked)
- **Versión Node.js**: `v20.0.0`
- **Versión Bun**: `v1.0.0`
- **Duración comando**: `2s`
- **Hora actual**: `[14:30]`

## 🎨 Layouts Específicos

### `dev` - Frontend Development
- **60%**: Terminal principal (editor, npm run dev, etc.)
- **20%**: Tests y comandos
- **20%**: Logs, build output

**Uso ideal:**
```bash
zellij --layout dev
# Panel principal: npm run dev
# Panel secundario: npm test
# Panel terciario: git log --oneline
```

### `git` - Git Workflow
- **40%**: `git status` (auto-ejecutado)
- **30%**: Terminal principal
- **30%**: `git log --oneline -10` (auto-ejecutado)

**Uso ideal:**
```bash
zellij --layout git
# Revisa cambios, haz commits, revisa historial
```

### `fullstack` - Frontend + Backend
- **50%**: Frontend (React/Vue/etc.)
- **50%**: Backend (Node.js, Python, etc.)

**Uso ideal:**
```bash
zellij --layout fullstack
# Panel izquierdo: npm run dev
# Panel derecho: npm run server:api
```

## 🔧 Atajos Especiales

### Productividad
```bash
# En cualquier momento dentro de Zellij:
Ctrl + g       # Modo Locked (bloquear terminal)
Ctrl + q       # Salir de Zellij
Ctrl + o       # Modo Session (manejar sesiones)

# Toggle pane floating/pinned
Alt + f        # Toggle pane flotante
Alt + p        # Toggle pane dentro de grupo
```

### Session Management
```bash
# Listar sesiones
zellij list-sessions

# Adjuntar a sesión específica
zellij attach session-name

# Crear sesión con nombre
zellij new-session --session-name my-project

# Detach de sesión actual
Ctrl + o → d
```

## 🎨 Temas y Apariencia

### Catppuccin Mocha
Todos los componentes usan el tema Catppuccin Mocha:
- **Background**: `#2D2A2E`
- **Foreground**: `#CDD6F4`
- **Accent Colors**: Rosa, Verde, Azul, Amarillo consistentes

### JetBrains Mono Nerd Font
- Fuente principal para todos los terminales
- Mejor legibilidad y soporte de íconos
- Tamaño 11px recomendado

## 📁 Gestión de Configuración

### Actualizar Configuraciones
```bash
# Cambios en shell-setup/ se reflejan automáticamente
# Reiniciar Alacritty o recargar Zellij para aplicar cambios
```

### Backups Automáticos
```bash
# Los scripts crean backups al sobreescribir configs
# Formato: archivo.backup.YYYYMMDD_HHMMSS
```

### Restaurar Configs
```bash
# WSL
rm ~/.config/starship.toml
mv ~/.config/starship.toml.backup.* ~/.config/starship.toml

# Windows
del "%APPDATA%\Alacritty\alacritty.toml"
ren "%APPDATA%\Alacritty\alacritty.toml.backup.*" alacritty.toml
```

## 🐛 Troubleshooting

### Issues Comunes
1. **Zellij no encuentra layouts**: Verificar que existan en `~/.config/zellij/layouts/` o en `~/.shell-setup/layouts/`
2. **Alacritty no reconoce fuentes**: Instalar JetBrains Mono Nerd Font en Windows
3. **Starship no funciona**: Verificar que esté en `.bashrc` y recargar con `source ~/.bashrc`
4. **Zellij no se inicia**: Asegurarse de que snap esté instalado en WSL (`sudo apt install snapd`)
5. **SSH con WSL**: Usar `wsl -d Ubuntu` en Windows terminal

### Resetear Entorno
```bash
# WSL
./install-wsl.sh

# Windows
.\install-windows.bat
```

## 🚀 Tips Adicionales

### Workflow Sugerido
1. **Mañana**: `zellij --layout dev` para proyecto principal
2. **Git workflow**: `zellij --layout git` antes/después commits
3. **Fullstack**: `zellij --layout fullstack` cuando necesitas ambos entornos

### Optimización de Performance
- Usar `start_suspended true` en layouts para paneles no inmediatos
- Cerrar pestañas Zellij no usadas con `Ctrl + t → x`
- Usar floating panes para tareas temporales

### Integración con VSCode/WebStorm
- Configurar terminal integrada para usar Zellij:
  ```json
  "terminal.integrated.defaultProfile.windows": "Alacritty"
  ```

## 📚 Referencias

- [Alacritty Documentation](https://github.com/alacritty/alacritty/wiki)
- [Zellij Documentation](https://zellij.dev/documentation)
- [Starship Documentation](https://starship.rs/guide/)
- [Catppuccin Theme](https://github.com/catppuccin/catppuccin)

---

**🚀 Happy coding!** Desarrollado con ❤️ para optimizar tu flujo de trabajo Windows + WSL.
