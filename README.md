# dotfiles

Arch Linux + Hyprland configuration managed with yadm.

![Desktop](.config/screenshot.png)

## Installation

### Prerequisites
- Fresh Arch Linux installation
- Network connectivity

### Clone and Deploy

```bash
pacman -S yadm
yadm clone https://github.com/mattredact/dotfiles.git
chmod +x ~/.config/setup/install.sh
~/.config/setup/install.sh
```

### Post-Install

Configure git credentials:
```bash
cp ~/.config/git/user-email.template ~/.config/git/user-email
cp ~/.config/git/github-email.template ~/.config/git/github-email
cp ~/.config/git/gitlab-email.template ~/.config/git/gitlab-email

# Edit with your information
$EDITOR ~/.config/git/{user,github,gitlab}-email
```

Reboot, select Hyprland from display manager.

## Stack

| Component | Tool |
|-----------|------|
| **Window Manager** | Hyprland |
| **Wallpaper** | hyprpaper |
| **Idle/Lock** | hypridle, hyprlock |
| **Panel** | Waybar |
| **Launcher** | Wofi |
| **Notifications** | Mako |
| **Terminal** | Kitty |
| **Shell** | Zsh + Starship |
| **Editor** | Neovim (LazyVim) |
| **File Manager** | Yazi (TUI), Thunar (GUI) |
| **Multiplexer** | Tmux |
| **CLI Tools** | eza, bat, ripgrep, fd, fzf, zoxide, btop, ncdu |
| **Containers** | Docker, Kubernetes (helm, k9s, kompose) |
| **IaC** | Terraform, OpenTofu, Ansible |
| **Font** | JetBrainsMono Nerd Font |

## Configuration

### Monitor Setup
Edit `~/.config/hypr/monitors.conf`

### Keybindings (SUPER = Win key)

| Binding | Action |
|---------|--------|
| SUPER + Enter | Terminal |
| SUPER + D | Launcher |
| SUPER + C | Close window |
| SUPER + 1-6 | Switch workspace |
| SUPER + H/J/K/L | Navigate windows |
| SUPER + SHIFT + H/J/K/L | Move windows |
| SUPER + ALT + H/J/K/L | Resize windows |
| CTRL + ALT + L | Lock screen |

### Themes

24 themes managed by `~/.config/themes/switch-theme.sh`. Each theme applies colors to Hyprland, Hyprlock, Waybar, Kitty, Mako, Wofi, and eza.

```bash
theme jellybeans    # Switch to a theme
theme               # Cycle to next
theme list          # Show all themes
theme current       # Show active theme
```

## Package Management

Install from package lists:
```bash
paru -S --needed - < ~/.config/setup/essential-packages.txt
paru -S --needed - < ~/.config/setup/aur-packages.txt
```

Update system:
```bash
paru                    # Pacman + AUR
flatpak update         # Flatpaks
```

## Dotfile Management

```bash
yadm status
yadm add <file>
yadm commit -m "description"
yadm push
```

## Notes

- Git config files with personal emails excluded from repo (use templates)
- AMD GPU utilities included (vulkan-radeon, corectrl, radeontop)
- Kubernetes tooling: kubectl, helm, k9s, kompose
- IaC: Terraform, OpenTofu, Ansible
- Security: UFW firewall, Yubikey support, etckeeper for /etc versioning
