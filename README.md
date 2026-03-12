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
└── zellij.kdl             # Configuración de Zellij (WSL, incluye layouts)
```

## 🚀 Instalación

### Opción recomendada: Instalación completa (Windows + WSL)

```powershell
# Ejecutar como Administrador en Windows
cd shell-setup
.\install-windows.bat
```

Este script instala automáticamente:
- Configuración de WSL (Zsh, Starship, Zellij, symlinks)
- Configuración de Windows (Alacritty)
- Plugins de productividad (Zsh Autosuggestions, Syntax Highlighting)

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

# Instalar IosevkaTerm Nerd Font
# Descargar desde: https://www.nerdfonts.com/font-downloads
```

#### WSL:
```bash
# Instalar herramientas básicas
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget git neovim build-essential

# Nota: Starship, Zellij, Zoxide y fzf se instalan automáticamente por el script
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

### Modern Unix Stack (Rust Tools)
El entorno incluye reemplazos modernos para los comandos clásicos de Linux:
- **`ls` → `eza`**: Listado con iconos, colores y jerarquía.
  - `ls`, `ll`, `la`, `lt` (árbol).
- **`cat` → `bat`**: Lectura de archivos con resaltado de sintaxis.
  - `cat archivo.js`
- **`grep` → `rg`**: Búsqueda de texto ultra rápida con Ripgrep.
  - `grep "texto" .`
- **`find` → `fd`**: Búsqueda de archivos simple y rápida.
  - `find nombre`
- **`cd` → `z`**: Navegación inteligente con Zoxide.
  - `cd proyecto` (salta al directorio más frecuente)

### fzf - Fuzzy Finder Interactivo
```bash
# Historial de comandos (Ctrl+R)
Ctrl + R       # Buscar en historial de comandos

# Buscar archivos (Ctrl+T)
Ctrl + T       # Buscar archivos en directorio actual

# Buscar directorios (Alt+C)
Alt + C        # Buscar directorios para cd

# Zoxide interactivo (usa fzf)
zi             # Buscar fuzzy entre directorios frecuentes
z -i           # Mismo que zi (alias)
z -l           # Listar directorios frecuentes con scores
z -            # Ir al directorio anterior
```

### Zoxide - Jump Directory Inteligente
```bash
# Salta a directorios frecuentes
z proyecto              # Salta a proyecto si lo has visitado mucho
zi proyecto             # Búsqueda interactiva con fzf (recomendado)

# Listar y manejar
z -l                    # Ver todos tus directorios frecuentes
z -r                    # Búsqueda con regex
z -s                    # Case insensitive
```

**Nota:** Zoxide aprende de tus visitas, usa `zi` para fuzzy search cuando no autocompleta.

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

## 🎨 Estética y Tema

El entorno utiliza un **Tema Oscuro Personalizado** de alto contraste, diseñado para reducir la fatiga visual y mejorar la legibilidad del código:

- **Fondo**: `#16161a` (Negro profundo)
- **Texto Principal**: `#E4E4E7` (Gris claro / Zinc)
- **Colores de Acento**:
  - **Verde**: `#A6E3A1` (Éxito y Prompt)
  - **Azul**: `#7DCFFF` (Directorios y Links)
  - **Magenta**: `#CBA6F7` (Keywords y Especiales)
  - **Cyan**: `#94E2D5` (FZF y Selección)

### IosevkaTerm Nerd Font
- Fuente principal para todos los terminales
- Mejor legibilidad y soporte de íconos
- Tamaño 13.0 recomendado


## 🛠️ Recuperación y Depuración (Troubleshooting)

Si algo llegara a fallar durante la instalación automática, puedes ejecutar estos pasos manualmente para recuperar el entorno:

### 1. Reinstalación de Zsh y Plugins
Si los plugins no cargan o Zsh falla:
```bash
# Reinstalar Zsh
sudo apt update && sudo apt install -y zsh

# Forzar descarga de plugins
rm -rf ~/.zsh/plugins
mkdir -p ~/.zsh/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/plugins/zsh-syntax-highlighting
```

### 2. Verificar Starship y Modern Unix
Si los comandos como `ls` o `cat` no muestran iconos o colores:
```bash
# Reinstalar binarios básicos
sudo apt install -y bat ripgrep fd-find zoxide

# Verificar symlinks para Ubuntu
mkdir -p ~/.local/bin
[ ! -f ~/.local/bin/fd ] && ln -s $(which fdfind) ~/.local/bin/fd
[ ! -f ~/.local/bin/bat ] && ln -s $(which batcat) ~/.local/bin/bat

# Recargar configuración
source ~/.zshrc
```

### 3. Problemas de Ruta (PATH)
Si recibes errores de `command not found`, asegúrate de que estas líneas estén al inicio de tu `~/.zshrc`:
```bash
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"
```

### 4. Resetear configuración completa
Si prefieres empezar de cero sin borrar tus archivos:
```bash
rm -rf ~/.shell-setup
rm ~/.zshrc ~/.bashrc ~/.starship.toml ~/.zellij.kdl
# Vuelve a correr: ./install-wsl.sh
```

---

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
1. **Zellij no encuentra layouts**: Los layouts están integrados en `zellij.kdl`
2. **Alacritty no reconoce fuentes**: Instalar IosevkaTerm Nerd Font en Windows
3. **Starship no funciona**: Verificar que esté en `.zshrc` (o `.bashrc`) y recargar con `source ~/.zshrc`
4. **Zellij no se inicia**: Asegurarse de que `zellij` esté instalado (`sudo apt install zellij` o `snap install zellij`)
5. **SSH con WSL**: Usar `wsl -d <distro_name>` en Windows terminal (ej: Ubuntu, Debian)

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
