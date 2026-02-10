#!/bin/bash

THEME_DIR="$HOME/.config/themes"
CURRENT_THEME_FILE="$THEME_DIR/.current-theme"
ACTIVE_ENV_FILE="$THEME_DIR/.active-env"
THEMES=(gruvbox moonfly tokyonight everforest jellybeans gyokuro hojicha iceclimber moon roseprime void lackluster emperor venom darkthrone aamis ash catppuccin felix solarized-osaka solarized gruvmat-hard gruvmat-med everblush)

# File mapping: source (in theme dir) -> destination
declare -A FILE_MAP=(
    [hypr-colors.conf]="$HOME/.config/hypr/colors.conf"
    [hyprlock-colors.conf]="$HOME/.config/hypr/hyprlock-colors.conf"
    [waybar-style.css]="$HOME/.config/waybar/style.css"
    [mako-config]="$HOME/.config/mako/config"
    [fuzzel.ini]="$HOME/.config/fuzzel/fuzzel.ini"
    [kitty-theme.conf]="$HOME/.config/kitty/current-theme.conf"
    [env-vars]="$ACTIVE_ENV_FILE"
    [eza-theme.yml]="$HOME/.config/eza/theme.yml"
)

# Optional files: copied if present, silently skipped if not
declare -A OPTIONAL_MAP=(
    [yazi-theme.toml]="$HOME/.config/yazi/theme.toml"
)

is_theme() {
    for t in "${THEMES[@]}"; do
        [[ "$t" == "$1" ]] && return 0
    done
    return 1
}

apply_theme() {
    local theme=$1
    local errors=0

    if [[ ! -d "$THEME_DIR/$theme" ]]; then
        echo "Error: Theme '$theme' not found"
        return 1
    fi

    echo "Applying $theme..."

    for src in "${!FILE_MAP[@]}"; do
        local dest="${FILE_MAP[$src]}"
        if [[ -f "$THEME_DIR/$theme/$src" ]]; then
            if ! cp "$THEME_DIR/$theme/$src" "$dest"; then
                echo "  Failed: $src"
                ((errors++))
            fi
        else
            echo "  Missing: $src"
            ((errors++))
        fi
    done

    # Optional files (silently skip if missing)
    for src in "${!OPTIONAL_MAP[@]}"; do
        local dest="${OPTIONAL_MAP[$src]}"
        if [[ -f "$THEME_DIR/$theme/$src" ]]; then
            cp "$THEME_DIR/$theme/$src" "$dest" || echo "  Failed: $src"
        fi
    done

    # Source env vars for current session
    [[ -f "$ACTIVE_ENV_FILE" ]] && source "$ACTIVE_ENV_FILE"

    echo "$theme" > "$CURRENT_THEME_FILE"

    # Reload applications
    hyprctl reload 2>/dev/null
    pkill -x waybar 2>/dev/null && sleep 0.2; waybar > /dev/null 2>&1 &
    pkill -x mako 2>/dev/null && sleep 0.2; mako > /dev/null 2>&1 &
    pkill -USR1 kitty 2>/dev/null

    if ((errors > 0)); then
        echo "Applied with $errors error(s)"
        return 1
    fi

    echo "$theme applied"
}

show_current() {
    if [[ -f "$CURRENT_THEME_FILE" ]]; then
        cat "$CURRENT_THEME_FILE"
    else
        echo "No theme set"
    fi
}

toggle_theme() {
    local current
    current=$(show_current)

    # Find current theme index and advance to next
    for i in "${!THEMES[@]}"; do
        if [[ "${THEMES[$i]}" == "$current" ]]; then
            local next=$(( (i + 1) % ${#THEMES[@]} ))
            echo "Switching from $current to ${THEMES[$next]}..."
            apply_theme "${THEMES[$next]}"
            return
        fi
    done

    # Unknown/no theme, default to first
    echo "Setting to ${THEMES[0]}..."
    apply_theme "${THEMES[0]}"
}

list_themes() {
    echo "Available themes:"
    for t in "${THEMES[@]}"; do
        printf "  %-14s %s\n" "$t" "$(get_theme_description "$t")"
    done
    echo ""
    echo "Current: $(show_current)"
}

get_theme_description() {
    case "$1" in
        gruvbox)     echo "Warm, earthy tones" ;;
        moonfly)     echo "Dark charcoal, vibrant accents" ;;
        tokyonight)  echo "Modern dark, vibrant colors" ;;
        everforest)  echo "Green-based, easy on the eyes" ;;
        jellybeans)  echo "Colorful dark, IR_Black inspired" ;;
        gyokuro)     echo "Neomodern, muted greens" ;;
        hojicha)     echo "Neomodern, warm browns" ;;
        iceclimber)  echo "Neomodern, cool blues" ;;
        moon)        echo "Neomodern, muted grays" ;;
        roseprime)   echo "Neomodern, dusty pinks" ;;
        void)        echo "Monochrome, pure black" ;;
        lackluster)  echo "Near-black, red pop" ;;
        emperor)     echo "Black metal, lavender accent" ;;
        venom)       echo "Black metal, blood red accent" ;;
        darkthrone)  echo "Black metal, pure monochrome" ;;
        aamis)       echo "Near-black, warm amber accent" ;;
        ash)         echo "Monochrome, soft grays" ;;
        catppuccin)  echo "Mocha pastels, near-black base" ;;
        felix)       echo "Pure black, monochrome + orange pop" ;;
        solarized-osaka) echo "Dark teal solarized, blue accent" ;;
        solarized)   echo "Classic solarized dark" ;;
        gruvmat-hard) echo "Gruvbox material, dark hard" ;;
        gruvmat-med) echo "Gruvbox material, dark medium" ;;
        everblush)   echo "Cool dark, pastel accents" ;;
        *)           echo "" ;;
    esac
}

validate_theme() {
    local theme=$1
    local theme_path="$THEME_DIR/$theme"

    echo "Validating $theme..."

    local missing=()
    for src in "${!FILE_MAP[@]}"; do
        if [[ ! -f "$theme_path/$src" ]]; then
            missing+=("$src")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "  Missing files:"
        printf "    %s\n" "${missing[@]}"
        return 1
    fi
    echo "  OK"
}

# Main
case "${1:-toggle}" in
    toggle)
        toggle_theme
        ;;
    current)
        current=$(show_current)
        echo "Current theme: $current"
        if [[ "$current" != "No theme set" ]]; then
            echo "$(get_theme_description "$current")"
        fi
        ;;
    list)
        list_themes
        ;;
    validate)
        if [[ -n "$2" ]]; then
            validate_theme "$2"
        else
            for theme in "${THEMES[@]}"; do
                validate_theme "$theme"
            done
        fi
        ;;
    -h|--help|help)
        echo "Usage: $0 [theme|command]"
        echo ""
        list_themes
        echo ""
        echo "Commands: toggle, current, list, validate"
        exit 1
        ;;
    *)
        if is_theme "$1"; then
            validate_theme "$1" && apply_theme "$1"
        else
            echo "Unknown theme: $1"
            echo "Run '$0 list' to see available themes"
            exit 1
        fi
        ;;
esac
