#!/bin/bash

WALL="$1"

# Save wallpaper path
echo "$WALL" > ~/.cache/current_wallpaper

# Set wallpaper using swww
swww img "$WALL"

# Generate Pywal theme
wal -i "$WALL"

# Apply GTK theme
wal-gtk -i "$WALL" --apply

# Reload Rofi to use new colors
pkill rofi
rofi -show drun -theme-str "$(cat ~/.cache/wal/colors-rofi-dark.rasi)" &
pkill waybar && waybar &

