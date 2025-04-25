#!/bin/bash

# --- Configuration ---
CACHE_DIR="${HOME}/.cache/wal"
TEMPLATE_FILE="${HOME}/.config/hypr/hyprlock.conf.tpl"
CONFIG_FILE="${HOME}/.config/hypr/hyprlock.conf"

# Check if essential files exist
if [[ ! -f "${CACHE_DIR}/colors.sh" ]]; then
    echo "Error: Pywal colors file not found at ${CACHE_DIR}/colors.sh"
    exit 1
fi
if [[ ! -f "$TEMPLATE_FILE" ]]; then
    echo "Error: Hyprlock template file not found at $TEMPLATE_FILE"
    exit 1
fi

# --- Source Pywal colors ---
# This loads variables like color0="#RRGGBB", background="#...", foreground="#..."
source "${CACHE_DIR}/colors.sh"

# --- Helper function ---
# Converts #RRGGBB to 0xAARRGGBB format for Hyprlock
# Usage: hex_to_hyprlock_int "$color0" "FF" -> 0xFFRRGGBB (opaque)
# Usage: hex_to_hyprlock_int "$color0" "AA" -> 0xAARRGGBB (custom alpha)
hex_to_hyprlock_int() {
    local hex_color="${1:-#000000}" # Default to black
    local alpha="${2:-FF}"         # Default to opaque (FF)
    local rgb_hex="${hex_color#\#}" # Remove '#'
    # Ensure 6 hex digits for RGB, padding with 0 if needed (handles short hex like #EEE)
    if [[ ${#rgb_hex} -eq 3 ]]; then
        local r="${rgb_hex:0:1}"
        local g="${rgb_hex:1:1}"
        local b="${rgb_hex:2:1}"
        rgb_hex="$r$r$g$g$b$b"
    elif [[ ${#rgb_hex} -ne 6 ]]; then
        rgb_hex="000000" # Fallback for invalid length
    fi
    echo "0x${alpha}${rgb_hex}"
}

# --- Prepare substitutions ---
wallpaper_path="${CACHE_DIR}/wal" # Get the wallpaper symlink path

# Create an associative array for replacements
declare -A replacements
replacements=(
    ["{{wallpaper_path}}"]="$wallpaper_path"
    ["{{background}}"]=$(hex_to_hyprlock_int "$background" "FF")
    ["{{foreground}}"]=$(hex_to_hyprlock_int "$foreground" "FF")
    ["{{cursor}}"]=$(hex_to_hyprlock_int "$cursor" "FF")
)

# Add standard color0-15 placeholders (opaque)
for i in {0..15}; do
    var_name="color$i"
    placeholder="{{color$i}}"
    replacements["$placeholder"]=$(hex_to_hyprlock_int "${!var_name}" "FF")
done

# Add custom placeholders defined in the template (e.g., with specific alpha)
# You need to define the placeholder AND the alpha value you want here.
# Example for the {{color0_alpha_AA}} placeholder in the template:
replacements["{{color0_alpha_AA}}"]=$(hex_to_hyprlock_int "$color0" "AA") # AA = ~66% alpha

# --- Generate sed command ---
sed_command="sed"
for placeholder in "${!replacements[@]}"; do
    # Escape characters that are special in sed patterns (like / and &)
    escaped_placeholder=$(sed 's/[&/\]/\\&/g' <<<"$placeholder")
    escaped_value=$(sed 's/[&/\]/\\&/g' <<<"${replacements[$placeholder]}")
    sed_command+=" -e \"s|$escaped_placeholder|$escaped_value|g\""
done

# --- Apply substitutions ---
eval "$sed_command" "$TEMPLATE_FILE" > "$CONFIG_FILE"

echo "Hyprlock config updated: $CONFIG_FILE"

exit 0