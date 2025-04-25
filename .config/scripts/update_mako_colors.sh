#!/bin/bash

# --- Configuration ---
CACHE_DIR="${HOME}/.cache/wal"
TEMPLATE_FILE="${HOME}/.config/mako/config.tpl"
CONFIG_FILE="${HOME}/.config/mako/config"

# Check if essential files exist
if [[ ! -f "${CACHE_DIR}/colors.sh" ]]; then
    echo "Error: Pywal colors file not found at ${CACHE_DIR}/colors.sh"
    exit 1
fi
if [[ ! -f "$TEMPLATE_FILE" ]]; then
    echo "Error: Mako template file not found at $TEMPLATE_FILE"
    exit 1
fi

# --- Source Pywal colors (provides variables like $background, $color1, etc.) ---
source "${CACHE_DIR}/colors.sh"

# --- Create associative array for replacements ---
# We can use the raw hex values directly (#RRGGBB)
declare -A replacements=(
    ["{{background}}"]="$background"
    ["{{foreground}}"]="$foreground"
    ["{{cursor}}"]="$cursor" # In case you want to use it
)

# Add color0-15 placeholders
for i in {0..15}; do
    var_name="color$i"
    placeholder="{{color$i}}"
    replacements["$placeholder"]="${!var_name}"
done

# --- Read template and perform substitutions ---
output_config=$(cat "$TEMPLATE_FILE")
for placeholder in "${!replacements[@]}"; do
    # Use simple bash substitution first (handles most cases)
    output_config="${output_config//"$placeholder"/"${replacements[$placeholder]}"}"
    # Fallback with sed for trickier cases if needed, but bash should work for these placeholders
    # escaped_placeholder=$(sed 's/[&/\\]/\\\\&/g' <<<"$placeholder")
    # escaped_value=$(sed 's/[&/\\]/\\\\&/g\' <<<"${replacements[$placeholder]}")
    # output_config=$(sed "s|$escaped_placeholder|$escaped_value|g" <<<"$output_config")
done

# --- Write the new config ---
echo "$output_config" > "$CONFIG_FILE"
echo "Mako config updated: $CONFIG_FILE"

# --- Reload Mako ---
if pgrep -x mako > /dev/null; then
    makoctl reload
    echo "Mako configuration reloaded."
else
    echo "Mako is not running, skipping reload."
fi

exit 0