#!/bin/bash

# WSL Installation Script for Shell Setup
# Run this script inside WSL (Ubuntu)

set -e

echo "Installing Shell Setup for WSL Development Environment"
echo "========================================================"

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHELL_SETUP_DIR="$SCRIPT_DIR"

echo "Shell setup directory: $SHELL_SETUP_DIR"

# Ask for sudo password once at the beginning
echo -e "${BLUE}[INFO] Checking for sudo access...${NC}"
if ! sudo -v; then
    echo -e "${RED}[ERROR] This script requires sudo access. Please run with a user that has sudo privileges.${NC}"
    exit 1
fi

# Keep sudo alive during script execution
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check if running from ~/.shell-setup, if not self-install
SHELL_SETUP_HOME="$HOME/.shell-setup"
if [ "$(realpath "$SCRIPT_DIR")" != "$(realpath "$SHELL_SETUP_HOME")" ]; then
    echo "Installing to $SHELL_SETUP_HOME..."

    # Create target directory
    mkdir -p "$SHELL_SETUP_HOME"

    # Copy only necessary files
    for file in alacritty.toml starship.toml zellij.kdl install-wsl.sh; do
        if [ -f "$SCRIPT_DIR/$file" ]; then
            cp "$SCRIPT_DIR/$file" "$SHELL_SETUP_HOME/"
            echo "  [OK] $file"
        fi
    done

    # Copy layouts directory if exists
    if [ -d "$SCRIPT_DIR/layouts" ]; then
        cp -r "$SCRIPT_DIR/layouts" "$SHELL_SETUP_HOME/"
        echo "  [OK] layouts/"
    fi

    echo "[OK] Files copied to $SHELL_SETUP_HOME"
    echo "[INFO] Re-running from $SHELL_SETUP_HOME..."
    exec bash "$SHELL_SETUP_HOME/install-wsl.sh"
fi

echo "[INFO] Running from: $SHELL_SETUP_HOME"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    local description="$3"

    if [ -L "$target" ]; then
        echo -e "${YELLOW}[INFO] $description already exists as symlink, updating...${NC}"
        rm "$target"
    elif [ -f "$target" ]; then
        echo -e "${YELLOW}[INFO] $description exists, backing up...${NC}"
        mv "$target" "$target.backup.$(date +%Y%m%d_%H%M%S)"
    fi

    echo -e "${BLUE}[INFO] Installing $description...${NC}"
    ln -sf "$source" "$target"
    echo -e "${GREEN}[OK] $description installed${NC}"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Installation functions
install_starship() {
    if ! command_exists starship; then
        echo -e "${BLUE}[INFO] Installing Starship...${NC}"
        curl -sS https://starship.rs/install.sh | sh
        echo -e "${GREEN}[OK] Starship installed${NC}"
    else
        echo -e "${YELLOW}[INFO] Starship already installed: $(starship --version)${NC}"
    fi
}

install_zellij() {
    if ! command_exists zellij; then
        echo -e "${BLUE}[INFO] Installing Zellij...${NC}"
        if command_exists snap; then
            sudo snap install zellij --classic
        elif command_exists apt; then
            sudo apt update
            sudo apt install -y zellij
        else
            echo -e "${RED}[ERROR] Neither snap nor apt found. Please install Zellij manually.${NC}"
            return 1
        fi
        echo -e "${GREEN}[OK] Zellij installed${NC}"
    else
        echo -e "${YELLOW}[INFO] Zellij already installed: $(zellij --version)${NC}"
    fi
}

install_zoxide() {
    if ! command_exists zoxide; then
        echo -e "${BLUE}[INFO] Installing Zoxide...${NC}"
        sudo apt update && sudo apt install -y zoxide
        echo -e "${GREEN}[OK] Zoxide installed${NC}"
    else
        echo -e "${YELLOW}[INFO] Zoxide already installed: $(zoxide --version)${NC}"
    fi
}

install_fzf() {
    if [ ! -d "$HOME/.fzf" ]; then
        echo -e "${BLUE}[INFO] Installing fzf...${NC}"
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all
        echo -e "${GREEN}[OK] fzf installed${NC}"
    else
        echo -e "${YELLOW}[INFO] fzf already installed${NC}"
    fi
}

install_zsh() {
    if ! command_exists zsh; then
        echo -e "${BLUE}[INFO] Installing Zsh...${NC}"
        sudo apt update && sudo apt install -y zsh
        echo -e "${GREEN}[OK] Zsh installed${NC}"
    else
        echo -e "${YELLOW}[INFO] Zsh already installed: $(zsh --version)${NC}"
    fi

    # Install plugins
    local plugin_dir="$HOME/.zsh/plugins"
    mkdir -p "$plugin_dir"

    if [ ! -d "$plugin_dir/zsh-autosuggestions" ]; then
        echo -e "${BLUE}[INFO] Installing zsh-autosuggestions...${NC}"
        git clone https://github.com/zsh-users/zsh-autosuggestions "$plugin_dir/zsh-autosuggestions"
    install_zsh() {
    ...
        if [ ! -d "$plugin_dir/zsh-syntax-highlighting" ]; then
            echo -e "${BLUE}[INFO] Installing zsh-syntax-highlighting...${NC}"
            git clone https://github.com/zsh-users/zsh-syntax-highlighting "$plugin_dir/zsh-syntax-highlighting"
        fi
    }

    install_modern_tools() {
        echo -e "${BLUE}[INFO] Installing Modern Unix Stack...${NC}"

        # eza (Reemplazo de ls)
        if ! command_exists eza; then
            echo -e "${BLUE}[INFO] Installing eza...${NC}"
            sudo mkdir -p /etc/apt/keyrings
            wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
            echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
            sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
            sudo apt update
            sudo apt install -y eza
        fi

        # bat, ripgrep, fd-find (Vía apt)
        sudo apt install -y bat ripgrep fd-find

        # Symlink para fd y bat (en Ubuntu a veces tienen nombres diferentes)
        mkdir -p "$HOME/.local/bin"
        [ -f /usr/bin/fdfind ] && [ ! -f "$HOME/.local/bin/fd" ] && ln -s /usr/bin/fdfind "$HOME/.local/bin/fd"
        [ -f /usr/bin/batcat ] && [ ! -f "$HOME/.local/bin/bat" ] && ln -s /usr/bin/batcat "$HOME/.local/bin/bat"

        echo -e "${GREEN}[OK] Modern Unix Stack installed${NC}"
    }

    update_bashrc() {
        local bashrc="$HOME/.bashrc"
        echo -e "${BLUE}[INFO] Updating ~/.bashrc...${NC}"

        # Path settings
        if ! grep -q ".local/bin" "$bashrc"; then
            echo -e "\n# Local Path\nexport PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$bashrc"
        fi

        if ! grep -q "starship init bash" "$bashrc"; then
            echo -e "\n# Starship Prompt\neval \"\$(starship init bash)\"" >> "$bashrc"
        fi

        if ! grep -q "zellij setup.*bash" "$bashrc"; then
            echo -e "\n# Zellij\neval \"\$(zellij setup --generate-completion bash)\"" >> "$bashrc"
        fi

        if ! grep -q "zoxide init bash" "$bashrc"; then
            echo -e "\n# Zoxide\neval \"\$(zoxide init bash)\"" >> "$bashrc"
        fi

        # Productivity Aliases
        if ! grep -q "alias ls='eza" "$bashrc"; then
            cat >> "$bashrc" << 'EOF'

    # Productivity Aliases
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -lh --icons --group-directories-first'
    alias la='eza -a --icons --group-directories-first'
    alias lt='eza --tree --icons'
    alias cat='bat --paging=never'
    alias grep='rg'
    alias find='fd'
    alias cd='z'
    EOF
        fi
    }

    update_zshrc() {
        local zshrc="$HOME/.zshrc"
        echo -e "${BLUE}[INFO] Updating ~/.zshrc...${NC}"

        if [ ! -f "$zshrc" ]; then
            touch "$zshrc"
        fi

        # Path settings (Added at the beginning)
        if ! grep -q ".cargo/bin" "$zshrc" || ! grep -q ".local/bin" "$zshrc"; then
            echo -e "# Path settings\nexport PATH=\"\$HOME/.cargo/bin:\$HOME/.local/bin:\$PATH\"\n$(cat "$zshrc")" > "$zshrc"
        fi

        # Basic Zsh config
        if ! grep -q "HISTFILE" "$zshrc"; then
            cat >> "$zshrc" << 'EOF'

    # History settings
    HISTFILE=~/.zsh_history
    HISTSIZE=10000
    SAVEHIST=10000
    setopt APPEND_HISTORY
    setopt SHARE_HISTORY
    setopt HIST_IGNORE_DUPS
    EOF
        fi

        # Plugins & FZF Integration
        if ! grep -q "zsh-autosuggestions" "$zshrc"; then
            cat >> "$zshrc" << 'EOF'

    # Plugins
    source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

    # FZF Integration
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
    EOF
        fi

        # Productivity Aliases
        if ! grep -q "alias ls='eza" "$zshrc"; then
            cat >> "$zshrc" << 'EOF'

    # Productivity Aliases
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -lh --icons --group-directories-first'
    alias la='eza -a --icons --group-directories-first'
    alias lt='eza --tree --icons'
    alias cat='bat --paging=never'
    alias grep='rg'
    alias find='fd'
    alias cd='z'
    EOF
        fi

        # Tools integration
        if ! grep -q "starship init zsh" "$zshrc"; then
            echo -e "\n# Starship Prompt\neval \"\$(starship init zsh)\"" >> "$zshrc"
        fi

        if ! grep -q "zellij setup.*zsh" "$zshrc"; then
            echo -e "\n# Zellij\neval \"\$(zellij setup --generate-completion zsh)\"" >> "$zshrc"
        fi

        if ! grep -q "zoxide init zsh" "$zshrc"; then
            echo -e "\n# Zoxide\neval \"\$(zoxide init zsh)\"" >> "$zshrc"
        fi
    }


# Main installation process
echo ""
echo "[INFO] Creating necessary directories..."

echo "[INFO] Installing configuration files..."

# Install Starship config
if [ -f "$SHELL_SETUP_DIR/starship.toml" ]; then
    create_symlink "$SHELL_SETUP_DIR/starship.toml" ~/.config/starship.toml "Starship config"
else
    echo -e "${RED}[ERROR] starship.toml not found${NC}"
fi

# Install Zellij config
if [ -f "$SHELL_SETUP_DIR/zellij.kdl" ]; then
    create_symlink "$SHELL_SETUP_DIR/zellij.kdl" ~/.config/zellij/config.kdl "Zellij config"
else
    echo -e "${RED}[ERROR] zellij.kdl not found${NC}"
fi

echo ""
echo "Verifying required software installation..."

# Install software
install_starship
install_zellij
install_zoxide
install_fzf
install_zsh
install_modern_tools

# Update shell configuration
update_bashrc
update_zshrc

# Ask to change default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo -e "\n${YELLOW}[?] Do you want to change your default shell to Zsh? (y/N)${NC}"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo -e "${BLUE}[INFO] Changing default shell to Zsh...${NC}"
        sudo chsh -s "$(which zsh)" "$USER"
        echo -e "${GREEN}[OK] Default shell changed to Zsh${NC}"
    fi
fi

echo ""
echo "WSL installation completed!"
echo "============================"
echo ""
echo -e "${GREEN}[OK] Files installed:${NC}"
echo -e "  ~/.config/starship.toml → shell-setup/starship.toml"
echo -e "  ~/.config/zellij/config.kdl → shell-setup/zellij.kdl"
echo -e "  ~/.zshrc (updated)"
echo -e "  ~/.bashrc (updated)"
echo ""
echo -e "${BLUE}[INFO] To apply changes:${NC}"
echo -e "  source ~/.zshrc (if using Zsh)"
echo -e "  source ~/.bashrc (if using Bash)"
echo -e "  OR restart your terminal"
echo ""
echo -e "${GREEN}[OK] Your WSL development environment is ready!${NC}"
