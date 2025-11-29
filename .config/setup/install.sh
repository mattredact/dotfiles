#!/usr/bin/env bash
set -e

echo "================================"
echo "Hyprland Dotfiles Setup Script"
echo "================================"
echo ""

# Check if running Arch
if [ ! -f /etc/arch-release ]; then
    echo "❌ This script is designed for Arch Linux"
    exit 1
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
info() { echo -e "${GREEN}==>${NC} $1"; }
warn() { echo -e "${YELLOW}==>${NC} $1"; }
error() { echo -e "${RED}==>${NC} $1"; }

# Install paru if not installed
if ! command -v paru &> /dev/null; then
    info "Installing paru AUR helper..."
    sudo pacman -S --needed --noconfirm base-devel git
    cd /tmp
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
    cd ~
else
    info "paru is already installed"
fi

# Install essential packages
info "Installing essential packages from official repos..."
paru -S --needed --noconfirm - < ~/.config/setup/essential-packages.txt

# Install AUR packages
info "Installing AUR packages..."
paru -S --needed --noconfirm - < ~/.config/setup/aur-packages.txt

# Set zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    info "Setting zsh as default shell..."
    chsh -s $(which zsh)
else
    info "zsh is already the default shell"
fi

# Enable user services
info "Enabling user services..."
systemctl --user enable --now pipewire pipewire-pulse wireplumber
systemctl --user enable hypridle.service

echo ""
info "✓ Installation complete!"
echo ""
warn "NEXT STEPS:"
echo "1. Log out and log back in for shell changes to take effect"
echo "2. Your dotfiles are already configured via yadm"
echo "3. Launch Hyprland and enjoy!"
echo ""
