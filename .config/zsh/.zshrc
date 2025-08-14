#!/usr/bin/env zsh

# Performance optimization - compile if needed
if [ ! -f "$ZDOTDIR/.zshrc.zwc" ] || [ "$ZDOTDIR/.zshrc" -nt "$ZDOTDIR/.zshrc.zwc" ]; then
    zcompile "$ZDOTDIR/.zshrc"
fi

###################
# CORE SETTINGS   #
###################

# Starship prompt
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# Navigation Options
setopt AUTO_CD              # Go to folder path without using cd
setopt AUTO_PUSHD          # Push the old directory onto the stack on cd
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd
setopt CDABLE_VARS          # Change directory to a path stored in a variable
setopt EXTENDED_GLOB        # Use extended globbing syntax

###################
# HISTORY         #
###################

setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format
setopt SHARE_HISTORY             # Share history between all sessions
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file
setopt HIST_VERIFY               # Do not execute immediately upon history expansion

###################
# COMPLETION      #
###################

# Initialize completion system
autoload -U compinit
zmodload zsh/complist
compinit
_comp_options+=(globdots)    # Include hidden files

# Completion styles
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' menu select
zstyle ':completion:*' increment yes
zstyle ':completion:*' squeeze-slashes yes
zstyle ':completion:*' file-sort modification
zstyle ':completion:*' list-dirs-first yes
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' ignored-patterns '.git'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' rehash false
zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

###################
# FZF INTEGRATION #
###################

eval "$(fzf --zsh)"
export FZF_COMPLETION_TRIGGER=''
bindkey '^T' fzf-completion
bindkey '^I' $fzf_default_completion

###################
# KEY BINDINGS    #
###################

# Emacs mode
bindkey -e
export KEYTIMEOUT=1

# Custom bindings
bindkey '^I' complete-word
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey '^[[3~' delete-char
bindkey -M emacs '\C-e' fzf-cd-widget

# Add more useful keybindings
bindkey '^[[1;5C' forward-word     # ctrl + right
bindkey '^[[1;5D' backward-word    # ctrl + left
bindkey '^U' backward-kill-line    # ctrl + u
bindkey '^K' kill-line            # ctrl + k
bindkey '^Y' yank                 # ctrl + y

###################
# PLUGINS         #
###################

# Auto-suggestions
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#606090'
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=40
    ZSH_AUTOSUGGEST_USE_ASYNC=1
fi

# Syntax highlighting
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    
    # Highlighters configuration
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
    ZSH_HIGHLIGHT_MAXLENGTH=120

    # Rainbow brackets
    ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=magenta'
    ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=green'
    ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=blue'
    ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=yellow'
    ZSH_HIGHLIGHT_STYLES[bracket-level-5]='fg=cyan'
    ZSH_HIGHLIGHT_STYLES[bracket-level-6]='fg=red'

    # Syntax styles
    ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,underline'
    ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=blue'
    ZSH_HIGHLIGHT_STYLES[precommand]='fg=cyan'
    ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=magenta'
    ZSH_HIGHLIGHT_STYLES[global-alias]='fg=magenta'
    ZSH_HIGHLIGHT_STYLES[arg0]='fg=magenta'
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=green'
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=green'
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=yellow'
    ZSH_HIGHLIGHT_STYLES[redirection]='fg=cyan'
    ZSH_HIGHLIGHT_STYLES[path]='none'
fi

###################
# ALIASES         #
###################

# Load aliases if they exist
[ -f "$ZDOTDIR/aliases" ] && source "$ZDOTDIR/aliases"

###################
# SYSTEM SPECIFIC #
###################

# Load local configurations if they exist
[ -f "$ZDOTDIR/.zshrc.local" ] && source "$ZDOTDIR/.zshrc.local"

# Fastfetch on start (consider moving this to .zlogin)
fastfetch

