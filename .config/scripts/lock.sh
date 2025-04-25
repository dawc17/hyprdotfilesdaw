#!/bin/bash

# Script to run swaylock with pywal colors

# Source the pywal colors
source "${HOME}/.cache/wal/colors.sh"

# Get the current wallpaper path from pywal cache
wallpaper_path=$(cat "${HOME}/.cache/wal/wal")

# Swaylock command using pywal colors and current wallpaper
# Adjust flags and colors as you like. See 'man swaylock' for options.
swaylock \
    --image "$wallpaper_path" \
    --indicator-radius 120 \
    --indicator-thickness 10 \
    \
    --ring-color "$background" \
    --key-hl-color "$color2" \
    --bs-hl-color "$color1" \
    --line-color "$background" \
    --inside-color "$background" \
    --separator-color "$background" \
    \
    --text-color "$foreground" \
    --text-caps-lock-color "$foreground" \
    --text-clear-color "$foreground" \
    --text-ver-color "$foreground" \
    \
    

