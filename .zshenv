#!/usr/bin/env zsh

###############################
# EXPORT ENVIRONMENT VARIABLE #
###############################

# Set environment variables
export TERM="xterm-256color"
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="kitty"
export BROWSER="firefox"
export QT_AUTO_SCREEN_SCALE_FACTOR=1
[[ -S "$XDG_RUNTIME_DIR/ssh-agent.socket" ]] && export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
# Theme env vars (BAT_THEME, FZF_DEFAULT_OPTS)
[[ -f "$HOME/.config/themes/.active-env" ]] && source "$HOME/.config/themes/.active-env"

# XDG
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_STATE_HOME="${HOME}/.local/state"

# Disable Home Dir Clutter
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export ANSIBLE_HOME="${XDG_DATA_HOME}/ansible"
export AWS_CONFIG_FILE="${XDG_CONFIG_HOME}/aws/config"
export AWS_SHARED_CREDENTIALS_FILE="${XDG_CONFIG_HOME}/aws/credentials"
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
export WGETRC="${XDG_CONFIG_HOME}/wget/wgetrc"
export XCURSOR_PATH="/usr/share/icons:${XDG_DATA_HOME}/icons"
export ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

# zsh
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export HISTFILE="$ZDOTDIR/.zhistory"    # History filepath
export HISTSIZE=5000                   # Maximum events for internal history
export SAVEHIST=5000                   # Maximum events in history file

# fzf (non-theme settings)
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -n 10'"
export FZF_COMPLETION_DIR_COMMANDS="cd pushd rmdir tree ls"

# eza uses ~/.config/eza/theme.yml for colors (hex, theme-independent)
# LS_COLORS disabled - it overrides eza's theme file

# Path (typeset -U prevents duplicates on re-source)
typeset -U path
path=("$HOME/.local/bin" $path)
