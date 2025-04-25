#!/bin/bash

# --- Configuration ---
WALLPAPER_DIR="$HOME/Photos/Wallpapers"
SET_WALLPAPER_CMD="swww img"
SWWW_OPTIONS="--transition-type any --transition-duration 1 --transition-fps 60"
# Ensure consistency with state file name
STATE_FILE="$HOME/.cache/current_wallpaper.txt"
CACHE_DIR="$HOME/.cache"
LOG_FILE="$CACHE_DIR/wallpapercycle.log"
WAYBAR_STYLE_SCRIPT="$HOME/.config/scripts/generate_waybar_style.sh"

# --- Functions ---

log_message() {
    mkdir -p "$CACHE_DIR" || { echo "Error: Could not create cache directory $CACHE_DIR" >&2; exit 1; }
    local log_dir
    log_dir=$(dirname "$LOG_FILE")
    if [[ ! -d "$log_dir" ]] || [[ ! -w "$log_dir" ]]; then
         echo "Error: Log directory $log_dir not writable or doesn't exist." >&2
         exit 1
    fi
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

error_exit() {
    log_message "ERROR: $1"
    echo "Error: $1" >&2
    log_message "--- Wallpaper Cycle Script END (Error) ---"
    exit 1
}

# --- Script Logic ---

# Optional: Clear log file at the start of each run
# > "$LOG_FILE"

log_message "--- Wallpaper Cycle Script START ---"
log_message "PID: $$"
log_message "Arguments received: $*"
log_message "User: $(whoami)"
log_message "Home: $HOME"
log_message "WAYLAND_DISPLAY: $WAYLAND_DISPLAY"
log_message "DISPLAY: $DISPLAY"
log_message "XDG_RUNTIME_DIR: $XDG_RUNTIME_DIR"
log_message "DBUS_SESSION_BUS_ADDRESS: $DBUS_SESSION_BUS_ADDRESS"
log_message "PATH: $PATH" # Check if wal, waybar etc. are in PATH

# (Directory Check, Wallpaper Search, Index Calculation - unchanged from previous logging version)
# ... (omitted for brevity, assume this part is the same as the working logging version) ...
# Check if wallpaper directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then error_exit "Wallpaper directory not found: $WALLPAPER_DIR"; fi
log_message "Wallpaper directory check OK: $WALLPAPER_DIR"
wallpapers=()
while IFS= read -r -d $'\0' file; do wallpapers+=("$file"); done < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.gif" \) -print0 | sort -z)
mapfile_status=$?; log_message "find/sort/mapfile status: $mapfile_status"; log_message "Found ${#wallpapers[@]} wallpapers."
if [ ${#wallpapers[@]} -eq 0 ]; then error_exit "No image files found in $WALLPAPER_DIR"; fi
current_wallpaper=""; if [ -f "$STATE_FILE" ]; then if read -r current_wallpaper < "$STATE_FILE"; then log_message "Read current wallpaper from state file ($STATE_FILE): [$current_wallpaper]"; else log_message "WARN: Could not read from state file ($STATE_FILE)"; current_wallpaper=""; fi else log_message "State file ($STATE_FILE) not found."; fi
current_index=-1; log_message "Searching for current wallpaper index..."; if [[ -n "$current_wallpaper" ]]; then current_wallpaper_abs=$(realpath "$current_wallpaper" 2>/dev/null); realpath_status=$?; if [ $realpath_status -ne 0 ]; then log_message "WARN: realpath failed for current wallpaper '$current_wallpaper' (status $realpath_status)."; current_wallpaper_abs=""; else log_message "Current wallpaper absolute path: [$current_wallpaper_abs]"; fi; if [[ -n "$current_wallpaper_abs" ]]; then for i in "${!wallpapers[@]}"; do wallpaper_i_abs=$(realpath "${wallpapers[$i]}" 2>/dev/null); if [[ "$wallpaper_i_abs" == "$current_wallpaper_abs" ]]; then current_index=$i; log_message "Found current wallpaper at index: $current_index"; break; fi; done; fi; else log_message "Current wallpaper variable is empty, skipping index search."; fi; if [ "$current_index" -eq -1 ]; then log_message "Current wallpaper index remains -1 (Not found or invalid)."; fi
direction="$1"; log_message "Direction argument: [$direction]"; total_wallpapers=${#wallpapers[@]}; next_index=0; if [ "$current_index" -eq -1 ]; then log_message "Current index is -1, calculating default next index."; if [ "$direction" == "prev" ]; then next_index=$((total_wallpapers - 1)); elif [ "$direction" == "next" ]; then next_index=0; else log_message "Warning: Invalid direction '$direction', defaulting to first wallpaper (index 0)."; next_index=0; fi; else log_message "Calculating next index based on current index $current_index."; if [ "$direction" == "prev" ]; then next_index=$(( (current_index - 1 + total_wallpapers) % total_wallpapers )); elif [ "$direction" == "next" ]; then next_index=$(( (current_index + 1) % total_wallpapers )); else error_exit "Invalid argument '$direction'. Use 'next' or 'prev'."; fi; fi; log_message "Calculated next index: $next_index"
if [ "$next_index" -lt 0 ] || [ "$next_index" -ge "$total_wallpapers" ]; then error_exit "FATAL: Calculated invalid next index: $next_index (Total: $total_wallpapers)"; fi
new_wallpaper="${wallpapers[$next_index]}"; if [[ -z "$new_wallpaper" ]]; then error_exit "FATAL: Failed to get wallpaper path for index $next_index."; fi
log_message "New wallpaper path determined: [$new_wallpaper]"
# --- End of unchanged section ---


# Check swww daemon (unchanged)
log_message "Checking if swww-daemon is running using 'pgrep -x swww-daemon'..."
pgrep_output=$(pgrep -x swww-daemon); pgrep_status=$?; log_message "pgrep status: $pgrep_status, output: [$pgrep_output]"
if [ $pgrep_status -ne 0 ]; then
    log_message "swww-daemon not found by pgrep (status $pgrep_status). Attempting to start with 'swww init'..."
    init_output=$(swww init 2>&1); init_status=$?; log_message "swww init status: $init_status"; log_message "swww init output: [$init_output]"
    if [ $init_status -ne 0 ]; then log_message "WARN: 'swww init' failed. Proceeding anyway..."; else log_message "'swww init' succeeded. Giving daemon a moment..."; sleep 1; fi
else log_message "swww-daemon found running by pgrep."; fi


# Set the new wallpaper using swww (unchanged)
log_message "Executing: $SET_WALLPAPER_CMD '$new_wallpaper' $SWWW_OPTIONS"
stdout_tmp=$(mktemp); stderr_tmp=$(mktemp)
$SET_WALLPAPER_CMD "$new_wallpaper" $SWWW_OPTIONS > "$stdout_tmp" 2> "$stderr_tmp"; set_status=$?
set_stdout=$(<"$stdout_tmp"); set_stderr=$(<"$stderr_tmp"); rm -f "$stdout_tmp" "$stderr_tmp"
log_message "swww img status: $set_status"; log_message "swww img stdout: [$set_stdout]"; log_message "swww img stderr: [$set_stderr]"
if [ $set_status -ne 0 ]; then error_exit "Failed to set wallpaper. 'swww img' exited with status $set_status."; fi
log_message "swww img command succeeded."


# --- NEW: Apply Colors and Reload Apps ---

# Generate Pywal theme
log_message "Generating Pywal theme with: wal -i '$new_wallpaper'"
wal_output=$(wal -i "$new_wallpaper" 2>&1); wal_status=$?
log_message "wal status: $wal_status"; log_message "wal output: [$wal_output]"
if [ $wal_status -ne 0 ]; then log_message "WARN: 'wal' command failed with status $wal_status."; fi

# Apply GTK theme (optional, depends on wal-gtk setup)
# Check if wal-gtk command exists before running
if command -v wal-gtk &> /dev/null; then
    log_message "Applying GTK theme with: wal-gtk -i '$new_wallpaper' --apply"
    wal_gtk_output=$(wal-gtk -i "$new_wallpaper" --apply 2>&1); wal_gtk_status=$?
    log_message "wal-gtk status: $wal_gtk_status"; log_message "wal-gtk output: [$wal_gtk_output]"
    if [ $wal_gtk_status -ne 0 ]; then log_message "WARN: 'wal-gtk' command failed with status $wal_gtk_status."; fi
else
    log_message "INFO: 'wal-gtk' command not found, skipping GTK theme apply."
fi


# Generate Waybar CSS (check if script exists and is executable)
if [ -x "$WAYBAR_STYLE_SCRIPT" ]; then
    log_message "Generating Waybar style with: $WAYBAR_STYLE_SCRIPT"
    waybar_script_output=$("$WAYBAR_STYLE_SCRIPT" 2>&1); waybar_script_status=$?
    log_message "Waybar style script status: $waybar_script_status"; log_message "Waybar style script output: [$waybar_script_output]"
    if [ $waybar_script_status -ne 0 ]; then log_message "WARN: Waybar style script '$WAYBAR_STYLE_SCRIPT' failed with status $waybar_script_status."; fi
else
    log_message "WARN: Waybar style script '$WAYBAR_STYLE_SCRIPT' not found or not executable. Skipping."
fi

# Reload Waybar
log_message "Reloading Waybar..."
pkill_output=$(pkill waybar 2>&1); pkill_status=$?
log_message "pkill waybar status: $pkill_status (0 or 1 is usually OK)"; log_message "pkill waybar output: [$pkill_output]"
# Brief pause before restarting waybar
sleep 0.5
log_message "Starting new Waybar instance in background..."
# Make sure waybar is in PATH or use absolute path
waybar &
log_message "Waybar restart command issued."

# Reload Rofi (optional)
log_message "Killing Rofi instances (if any)..."
pkill rofi > /dev/null 2>&1 # Ignore output/status, just try to kill existing ones
log_message "pkill rofi command issued."

# --- End of NEW section ---


# Update the state file (unchanged)
log_message "Updating state file $STATE_FILE with [$new_wallpaper]"
mkdir -p "$(dirname "$STATE_FILE")" || log_message "WARN: mkdir -p failed for $(dirname "$STATE_FILE") (status $?). Continuing..."
echo "$new_wallpaper" > "$STATE_FILE"; write_status=$?
if [ $write_status -ne 0 ]; then log_message "WARN: Failed to write to state file $STATE_FILE (status $write_status)."; else log_message "State file updated successfully."; fi


log_message "Wallpaper changed and theme applied (check logs for warnings)."
log_message "--- Wallpaper Cycle Script END (Success) ---"
exit 0