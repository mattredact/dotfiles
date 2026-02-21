#!/bin/bash

THEME_DIR="$HOME/.config/themes"
TEMPLATE_DIR="$THEME_DIR/templates"
CURRENT_THEME_FILE="$THEME_DIR/.current-theme"
ACTIVE_ENV_FILE="$THEME_DIR/.active-env"
THEMES=(
    jellybeans
    carbonfox
    miasma
    vantablack
)

# Output mapping: generated filename -> destination
declare -A DEST_MAP=(
    [hypr-colors.conf]="$HOME/.config/hypr/colors.conf"
    [hyprlock-colors.conf]="$HOME/.config/hypr/hyprlock-colors.conf"
    [waybar-style.css]="$HOME/.config/waybar/style.css"
    [mako-config]="$HOME/.config/mako/config"
    [fuzzel.ini]="$HOME/.config/fuzzel/fuzzel.ini"
    [kitty-theme.conf]="$HOME/.config/kitty/current-theme.conf"
    [env-vars]="$ACTIVE_ENV_FILE"
    [yazi-theme.toml]="$HOME/.config/yazi/theme.toml"
)

# Template -> output filename mapping
declare -A TPL_MAP=(
    [hypr-colors.tpl]="hypr-colors.conf"
    [hyprlock-colors.tpl]="hyprlock-colors.conf"
    [waybar-style.tpl]="waybar-style.css"
    [mako-config.tpl]="mako-config"
    [fuzzel.tpl]="fuzzel.ini"
    [kitty-theme.tpl]="kitty-theme.conf"
    [env-vars.tpl]="env-vars"
    [yazi-theme.tpl]="yazi-theme.toml"
)

# --- Color conversion helpers ---

hex_strip() { echo "${1#\#}"; }

hex_to_hypr() { echo "0xff$(hex_strip "$1")"; }

hex_to_rgb() {
    local hex
    hex=$(hex_strip "$1")
    printf "rgb(%d, %d, %d)" "0x${hex:0:2}" "0x${hex:2:2}" "0x${hex:4:2}"
}

hex_to_fuzzel() { echo "$(hex_strip "$1")ff"; }

# --- Template engine ---

build_sed_script() {
    local sed_file="$1"
    > "$sed_file"

    # All color variables that need format conversion
    local vars=(BG FG ACCENT SURFACE CURSOR SEL_FG SEL_BG DIM BORDER_INACTIVE URL
                COLOR0 COLOR1 COLOR2 COLOR3 COLOR4 COLOR5 COLOR6 COLOR7
                COLOR8 COLOR9 COLOR10 COLOR11 COLOR12 COLOR13 COLOR14 COLOR15
                COLOR_RED COLOR_GREEN COLOR_YELLOW COLOR_PURPLE)

    # Hyprland-specific vars (jellybeans has separate palette)
    local hypr_vars=(HYPR_BG HYPR_FG HYPR_BLACK HYPR_RED HYPR_GREEN HYPR_YELLOW
                     HYPR_BLUE HYPR_PURPLE HYPR_CYAN HYPR_WHITE
                     HYPR_BLACKBR HYPR_REDBR HYPR_GREENBR HYPR_YELLOWBR
                     HYPR_BLUEBR HYPR_PURPLEBR HYPR_CYANBR HYPR_WHITEBR HYPR_DIM)

    # If HYPR_BG is not set, copy main colors to HYPR_* vars
    if [[ -z "$HYPR_BG" ]]; then
        HYPR_BG="$BG"; HYPR_FG="$FG"; HYPR_DIM="$DIM"
        HYPR_BLACK="$COLOR0"; HYPR_RED="$COLOR1"; HYPR_GREEN="$COLOR2"
        HYPR_YELLOW="$COLOR3"; HYPR_BLUE="$COLOR4"; HYPR_PURPLE="$COLOR5"
        HYPR_CYAN="$COLOR6"; HYPR_WHITE="$COLOR7"
        HYPR_BLACKBR="$COLOR8"; HYPR_REDBR="$COLOR9"; HYPR_GREENBR="$COLOR10"
        HYPR_YELLOWBR="$COLOR11"; HYPR_BLUEBR="$COLOR12"; HYPR_PURPLEBR="$COLOR13"
        HYPR_CYANBR="$COLOR14"; HYPR_WHITEBR="$COLOR15"
    fi

    # Simple substitutions (metadata)
    echo "s|{{NAME}}|$NAME|g" >> "$sed_file"
    echo "s|{{BAT_THEME}}|$BAT_THEME|g" >> "$sed_file"
    echo "s|{{FONT_SIZE}}|$FONT_SIZE|g" >> "$sed_file"
    echo "s|{{WAYBAR_FONT_SIZE}}|$WAYBAR_FONT_SIZE|g" >> "$sed_file"

    # Color vars: generate all format variants
    for var in "${vars[@]}"; do
        local val="${!var}"
        [[ -z "$val" ]] && continue
        echo "s|{{${var}}}|$val|g" >> "$sed_file"
        echo "s|{{${var}_HYPR}}|$(hex_to_hypr "$val")|g" >> "$sed_file"
        echo "s|{{${var}_RGB}}|$(hex_to_rgb "$val")|g" >> "$sed_file"
        echo "s|{{${var}_FUZZEL}}|$(hex_to_fuzzel "$val")|g" >> "$sed_file"
        echo "s|{{${var}_STRIP}}|$(hex_strip "$val")|g" >> "$sed_file"
    done

    # Hyprland-specific vars
    for var in "${hypr_vars[@]}"; do
        local val="${!var}"
        [[ -z "$val" ]] && continue
        echo "s|{{${var}}}|$val|g" >> "$sed_file"
        echo "s|{{${var}_HYPR}}|$(hex_to_hypr "$val")|g" >> "$sed_file"
        echo "s|{{${var}_RGB}}|$(hex_to_rgb "$val")|g" >> "$sed_file"
        echo "s|{{${var}_STRIP}}|$(hex_strip "$val")|g" >> "$sed_file"
    done
}

generate_theme() {
    local theme="$1"
    local theme_path="$THEME_DIR/$theme"
    local errors=0

    # Source the color definitions
    source "$theme_path/colors.conf"

    # Build sed substitution script
    local sed_file
    sed_file=$(mktemp)
    build_sed_script "$sed_file"

    # Process each template
    for tpl in "${!TPL_MAP[@]}"; do
        local output="${TPL_MAP[$tpl]}"
        local dest="${DEST_MAP[$output]}"
        local tpl_path="$TEMPLATE_DIR/$tpl"

        if [[ ! -f "$tpl_path" ]]; then
            echo "  Missing template: $tpl"
            ((errors++))
            continue
        fi

        if ! sed -f "$sed_file" "$tpl_path" > "$dest"; then
            echo "  Failed: $output"
            ((errors++))
        fi
    done

    # Append extras (miasma animations, etc.) to hypr-colors.conf
    if [[ -f "$theme_path/extras.conf" ]]; then
        echo "" >> "${DEST_MAP[hypr-colors.conf]}"
        cat "$theme_path/extras.conf" >> "${DEST_MAP[hypr-colors.conf]}"
    fi

    # Write static eza theme (ANSI-inherited)
    echo "colourful: false" > "$HOME/.config/eza/theme.yml"

    rm -f "$sed_file"
    return "$errors"
}

# --- Theme operations ---

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

    generate_theme "$theme"
    errors=$?

    echo "$theme" > "$CURRENT_THEME_FILE"

    # Reload applications
    hyprctl reload 2>/dev/null
    pkill -x waybar 2>/dev/null
    sleep 0.3
    waybar > /dev/null 2>&1 &
    disown
    pkill -x mako 2>/dev/null
    sleep 0.3
    mako > /dev/null 2>&1 &
    disown
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

    for i in "${!THEMES[@]}"; do
        if [[ "${THEMES[$i]}" == "$current" ]]; then
            local next=$(( (i + 1) % ${#THEMES[@]} ))
            echo "Switching from $current to ${THEMES[$next]}..."
            apply_theme "${THEMES[$next]}"
            return
        fi
    done

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
        jellybeans)  echo "Colorful dark, IR_Black inspired" ;;
        carbonfox)   echo "IBM Carbon, purple + cyan" ;;
        miasma)      echo "Earthy olive/amber/brown tones" ;;
        vantablack)  echo "Near-black monochrome" ;;
        *)           echo "" ;;
    esac
}

validate_theme() {
    local theme=$1
    local theme_path="$THEME_DIR/$theme"

    echo "Validating $theme..."

    local missing=()

    if [[ ! -f "$theme_path/colors.conf" ]]; then
        missing+=("colors.conf")
    fi

    for tpl in "${!TPL_MAP[@]}"; do
        if [[ ! -f "$TEMPLATE_DIR/$tpl" ]]; then
            missing+=("templates/$tpl")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "  Missing files:"
        printf "    %s\n" "${missing[@]}"
        return 1
    fi
    echo "  OK"
}

# --- Main ---

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
        exit 0
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
