#!/bin/bash

# WSL Installation Script for Shell Setup
# Run this script inside WSL (Ubuntu)

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Installing Shell Setup for WSL Development Environment${NC}"
echo "========================================================"

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHELL_SETUP_DIR="$SCRIPT_DIR"

# Check if running from ~/.shell-setup, if not self-install
SHELL_SETUP_HOME="$HOME/.shell-setup"
if [ "$(realpath "$SCRIPT_DIR")" != "$(realpath "$SHELL_SETUP_HOME")" ]; then
    echo "Installing to $SHELL_SETUP_HOME..."
    mkdir -p "$SHELL_SETUP_HOME"
    for file in alacritty.toml starship.toml zellij.kdl install-wsl.sh; do
        [ -f "$SCRIPT_DIR/$file" ] && cp "$SCRIPT_DIR/$file" "$SHELL_SETUP_HOME/"
    done
    [ -d "$SCRIPT_DIR/layouts" ] && cp -r "$SCRIPT_DIR/layouts" "$SHELL_SETUP_HOME/"
    echo "[OK] Files copied to $SHELL_SETUP_HOME"
    exec bash "$SHELL_SETUP_HOME/install-wsl.sh"
fi

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    local description="$3"
    mkdir -p "$(dirname "$target")"
    [ -L "$target" ] && rm "$target"
    [ -f "$target" ] && mv "$target" "$target.backup.$(date +%Y%m%d_%H%M%S)"
    ln -sf "$source" "$target"
    echo -e "${GREEN}[OK] $description installed${NC}"
}

# Installation functions
install_starship() {
    if ! command_exists starship; then
        echo -e "${BLUE}[INFO] Installing Starship...${NC}"
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    fi
}

install_zellij() {
    if ! command_exists zellij; then
        echo -e "${BLUE}[INFO] Installing Zellij...${NC}"
        sudo apt update && sudo apt install -y zellij || true
    fi
}

install_modern_tools() {
    echo -e "${BLUE}[INFO] Installing Modern Unix Stack...${NC}"
    
    # eza
    if ! command_exists eza; then
        sudo mkdir -p /etc/apt/keyrings
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
        echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
        sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
        sudo apt update && sudo apt install -y eza
    fi

    # bat, rg, fd, zoxide
    sudo apt install -y bat ripgrep fd-find zoxide

    # Symlinks for Ubuntu
    mkdir -p "$HOME/.local/bin"
    [ -f /usr/bin/fdfind ] && [ ! -f "$HOME/.local/bin/fd" ] && ln -s /usr/bin/fdfind "$HOME/.local/bin/fd"
    [ -f /usr/bin/batcat ] && [ ! -f "$HOME/.local/bin/bat" ] && ln -s /usr/bin/batcat "$HOME/.local/bin/bat"
}

install_fzf() {
    if [ ! -d "$HOME/.fzf" ]; then
        echo -e "${BLUE}[INFO] Installing fzf...${NC}"
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all --no-bash --no-zsh --no-fish
    fi
}

install_zsh() {
    if ! command_exists zsh; then
        sudo apt update && sudo apt install -y zsh
    fi
    local plugin_dir="$HOME/.zsh/plugins"
    mkdir -p "$plugin_dir"
    [ ! -d "$plugin_dir/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions "$plugin_dir/zsh-autosuggestions"
    [ ! -d "$plugin_dir/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting "$plugin_dir/zsh-syntax-highlighting"
}

update_zshrc() {
    local zshrc="$HOME/.zshrc"
    echo -e "${BLUE}[INFO] Updating ~/.zshrc...${NC}"
    [ ! -f "$zshrc" ] && touch "$zshrc"

    # Define the configuration block
    local config_block="
# --- Shell Setup Auto-Generated ---
export PATH=\"\$HOME/.local/bin:\$HOME/.cargo/bin:\$PATH\"

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS

# Plugins
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# FZF Integration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Productivity Aliases
alias ls='eza --icons --group-directories-first'
alias ll='eza -lh --icons --group-directories-first'
alias la='eza -a --icons --group-directories-first'
alias lt='eza --tree --icons'
alias cat='bat --paging=never'
alias grep='rg'
alias find='fd'
alias cd='z'

# Tools Initialization
eval \"\$(starship init zsh)\"
eval \"\$(zoxide init zsh)\"
# ----------------------------------
"

    if ! grep -q "Shell Setup Auto-Generated" "$zshrc"; then
        echo "$config_block" >> "$zshrc"
    fi
}

# Execution
sudo -v
install_starship
install_zellij
install_modern_tools
install_fzf
install_zsh
update_zshrc

# Config files
create_symlink "$SHELL_SETUP_DIR/starship.toml" ~/.config/starship.toml "Starship config"
create_symlink "$SHELL_SETUP_DIR/zellij.kdl" ~/.config/zellij/config.kdl "Zellij config"

# Change shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo -e "\n${YELLOW}[?] Do you want to change your default shell to Zsh? (y/n)${NC}"
    read -r response
    if [[ "$response" =~ ^([yY])$ ]]; then
        sudo chsh -s "$(which zsh)" "$USER"
        echo -e "${GREEN}[OK] Shell changed to Zsh. Please restart your terminal.${NC}"
    fi
fi

echo -e "\n${GREEN}WSL Installation Completed!${NC}"
