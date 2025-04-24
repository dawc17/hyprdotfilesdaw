#!/bin/bash

WALL=$(cat ~/.cache/current_wallpaper)

if [ -f "$WALL" ]; then
    ~/.config/scripts/set_wallpaper.sh "$WALL"
    pkill rofi
    rofi -show drun -theme-str "$(cat ~/.cache/wal/colors-rofi-dark.rasi)" &
fi