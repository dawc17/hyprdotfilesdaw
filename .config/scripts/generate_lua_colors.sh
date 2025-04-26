#!/bin/bash

# --- Configuration ---
CACHE_DIR="${HOME}/.cache/wal"
TEMPLATE_FILE="${HOME}/.config/wal/templates/colors.lua.tpl"
# Output file location - place it where Neovim can easily require it
OUTPUT_FILE="${HOME}/.config/nvim/lua/config/colors.lua"
OUTPUT_DIR=$(dirname "$OUTPUT_FILE")

# Check if essential files exist
if [[ ! -f "${CACHE_DIR}/colors.sh" ]]; then
    echo "Error: Pywal colors file not found at ${CACHE_DIR}/colors.sh" >&2
    exit 1
fi
if [[ ! -f "$TEMPLATE_FILE" ]]; then
    echo "Error: Lua colors template file not found at $TEMPLATE_FILE" >&2
    exit 1
fi

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR" || { echo "Error: Could not create output directory $OUTPUT_DIR" >&2; exit 1; }

# --- Source Pywal colors (provides shell variables like $background, $color1, etc.) ---
source "${CACHE_DIR}/colors.sh"

# --- Prepare substitutions ---
# Create an associative array for replacements
declare -A replacements=(
    ["{{timestamp}}"]="$(date)" # Add current timestamp
    ["{{background}}"]="$background"
    ["{{foreground}}"]="$foreground"
    ["{{cursor}}"]="$cursor"
)

# Add color0-15 placeholders
for i in {0..15}; do
    var_name="color$i"
    placeholder="{{color$i}}"
    replacements["$placeholder"]="${!var_name}"
done

# --- Read template and perform substitutions ---
output_lua=$(cat "$TEMPLATE_FILE")
for placeholder in "${!replacements[@]}"; do
    # Need to escape replacements slightly for Lua strings (though hex codes are usually safe)
    # Simple substitution should work here
    escaped_value="${replacements[$placeholder]}" # No complex escaping needed for hex codes
    output_lua="${output_lua//"$placeholder"/"$escaped_value"}"
done

# --- Write the new Lua config file ---
echo "$output_lua" > "$OUTPUT_FILE"
echo "Pywal Lua colors updated: $OUTPUT_FILE"

exit 0
