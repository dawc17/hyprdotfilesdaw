#!/bin/bash

WALL="$1"

# Save wallpaper path
echo "$WALL" > ~/.cache/current_wallpaper

# Set wallpaper using swww
swww img "$WALL"

# Generate Pywal theme
wal -i "$WALL"
~/.config/scripts/update_mako_colors.sh

# Generate Waybar CSS from Pywal colors
~/.config/scripts/generate_waybar_style.sh

# Reload Waybar
pkill waybar
waybar &

# Reload Rofi (if needed)
pkill rofi

