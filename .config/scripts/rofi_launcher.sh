#!/bin/bash

# Apply the current Pywal color scheme to Rofi each time it launches
rofi -show drun -theme-str "$(cat ~/.cache/wal/colors-rofi-dark.rasi)"
