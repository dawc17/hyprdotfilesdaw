# ~/.config/hyprlock/hyprlock.conf.tpl

general {
    disable_loading_bar = false
    hide_cursor = true
    grace = 0
}

background {
    # Use the wallpaper path placeholder
    path = {{wallpaper_path}}
    # Fallback color (optional) - uses background color placeholder
    # color = {{background}}
    blur_passes = 2
    blur_size = 8
}

input-field {
    size = 250, 50
    outline_thickness = 2
    dots_size = 0.3
    dots_spacing = 0.15
    dots_center = true
    # Use color placeholders - these will be replaced with 0xAARRGGBB format
    # Example: Use color0 with ~66% alpha (AA hex) - see script notes
    inner_color = {{color0_alpha_AA}}
    # Opaque foreground (color7) for the border
    outer_color = {{color7}}
    # Font color (opaque foreground)
    font_color = {{foreground}}
    fade_on_empty = false
    placeholder_text = <i>Password...</i>
    hide_input = false
    position = 0, -100
    halign = center
    valign = center
}

label { # Clock
    monitor =
    text = cmd[update:1000] echo "$(date +"%H:%M")"
    # Use color7 (usually white/light gray)
    color = {{color7}}
    # Or try an accent color:
    # color = {{color4}}
    font_size = 90
    font_family = Noto Sans # Ensure you have this font installed
    position = 0, 150
    halign = center
    valign = center
}

label { # User text
    monitor =
    text = Hi $USER!
    color = {{color7}} # Adjust as needed
    font_size = 25
    font_family = Noto Sans
    position = 0, 50
    halign = center
    valign = center
}

# Add other elements as needed, using placeholders like {{colorN}} or {{background}} / {{foreground}}