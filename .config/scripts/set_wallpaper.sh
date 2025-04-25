#!/bin/bash

WALL="$1"

# Save wallpaper path
echo "$WALL" > ~/.cache/current_wallpaper

# Set wallpaper using swww
swww img "$WALL"

# Generate Pywal theme
wal -i "$WALL"

# Generate Waybar CSS from Pywal colors
~/.config/scripts/generate_waybar_style.sh

# Reload Waybar
pkill waybar
waybar &

# Reload Rofi (if needed)
pkill rofi
rofi -show drun -theme-str "$(cat ~/.cache/wal/colors-rofi-dark.rasi)" &

