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
        echo -e "${YELLOW}[INFO] Password required for apt install${NC}"
        sudo apt update && sudo apt install -y zoxide
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}[OK] Zoxide installed${NC}"
        else
            echo -e "${RED}[ERROR] Failed to install Zoxide. Run manually: sudo apt install zoxide${NC}"
        fi
    else
        echo -e "${YELLOW}[INFO] Zoxide already installed: $(zoxide --version)${NC}"
    fi
}

update_bashrc() {
    local bashrc="$HOME/.bashrc"
    local starship_init='eval "$(starship init bash)"'
    local zellij_init='eval "$(zellij setup --generate-auto-start bash)"'
    local zoxide_init='eval "$(zoxide init bash)"'

    echo -e "${BLUE}[INFO] Updating ~/.bashrc...${NC}"

    if ! grep -q "starship init bash" "$bashrc"; then
        echo -e "\\n# Starship Prompt" >> "$bashrc"
        echo "$starship_init" >> "$bashrc"
        echo -e "${GREEN}[OK] Added Starship to ~/.bashrc${NC}"
    else
        echo -e "${YELLOW}[INFO] Starship already in ~/.bashrc${NC}"
    fi

    if ! grep -q "zellij setup.*bash" "$bashrc"; then
        echo -e "\\n# Zellij Terminal Multiplexer" >> "$bashrc"
        echo "$zellij_init" >> "$bashrc"
        echo -e "${GREEN}[OK] Added Zellij to ~/.bashrc${NC}"
    else
        echo -e "${YELLOW}[INFO] Zellij already in ~/.bashrc${NC}"
    fi

    if ! grep -q "zoxide init bash" "$bashrc"; then
        echo -e "\\n# Zoxide Jump Directory" >> "$bashrc"
        echo "$zoxide_init" >> "$bashrc"
        echo -e "${GREEN}[OK] Added Zoxide to ~/.bashrc${NC}"
    else
        echo -e "${YELLOW}[INFO] Zoxide already in ~/.bashrc${NC}"
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

# Update shell configuration
update_bashrc

echo ""
echo "WSL installation completed!"
echo "============================"
echo ""
echo -e "${GREEN}[OK] Files installed:${NC}"
echo -e "  ~/.config/starship.toml → shell-setup/starship.toml"
echo -e "  ~/.config/zellij/config.kdl → shell-setup/zellij.kdl"
echo ""
echo -e "${BLUE}[INFO] To apply changes:${NC}"
echo -e "  source ~/.bashrc"
echo -e "  OR restart your terminal"
echo ""
echo -e "${GREEN}[OK] Your WSL development environment is ready!${NC}"