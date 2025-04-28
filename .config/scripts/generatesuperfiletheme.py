import json
import os
import toml  # You might need to install this: pip install toml

# --- Configuration ---
wal_colors_file = os.path.expanduser("$HOME/.cache/wal/colors.json")
# --- IMPORTANT: Set this to your actual theme directory ---
superfile_theme_dir = os.path.expanduser("$HOME/.config/superfile/theme/")
# --- IMPORTANT: This is the name of the theme file to generate ---
output_theme_file = os.path.join(superfile_theme_dir, "pywal.toml")
# --- Choose a chroma theme ---
chroma_theme = "monokai"  # Or another theme like "monokai", "catppuccin-mocha"
# ---

# --- Create theme directory if it doesn't exist ---
os.makedirs(superfile_theme_dir, exist_ok=True)
# ---


def generate_theme(colors):
    """Generates the theme TOML content from pywal colors."""

    # Extract colors (handle potential missing keys gracefully, though unlikely with pywal)
    specials = colors.get("special", {})
    palette = colors.get("colors", {})

    bg = specials.get("background", "#000000")
    fg = specials.get("foreground", "#ffffff")
    cursor = specials.get("cursor", fg)  # Default cursor to foreground if not specified

    c = [palette.get(f"color{i}", "#000000") for i in range(16)]  # Get color0-15

    theme_data = {
        "code_syntax_highlight": chroma_theme,
        # Borders
        "file_panel_border": c[0],
        "sidebar_border": bg,  # Hidden border
        "footer_border": c[0],
        # Active Borders
        "file_panel_border_active": c[4],  # Blue
        "sidebar_border_active": c[1],  # Red
        "footer_border_active": c[2],  # Green
        "modal_border_active": c[8],  # Bright Black/Grey
        # Backgrounds
        "full_screen_bg": bg,
        "file_panel_bg": bg,
        "sidebar_bg": bg,
        "footer_bg": bg,
        "modal_bg": bg,
        # Foregrounds
        "full_screen_fg": fg,
        "file_panel_fg": fg,
        "sidebar_fg": fg,
        "footer_fg": fg,
        "modal_fg": fg,
        # Special Colors
        "cursor": cursor,
        "correct": c[2],  # Green
        "error": c[1],  # Red
        "hint": c[3],  # Yellow
        "cancel": c[5],  # Magenta
        "gradient_color": [c[4], c[6]],  # Blue, Cyan
        # File Panel
        "file_panel_top_directory_icon": c[2],  # Green
        "file_panel_top_path": c[4],  # Blue
        "file_panel_item_selected_fg": c[6],  # Cyan
        "file_panel_item_selected_bg": c[8],  # Bright Black/Grey (adjust if needed)
        # Sidebar
        "sidebar_title": c[6],  # Cyan
        "sidebar_item_selected_fg": c[4],  # Blue
        "sidebar_item_selected_bg": c[8],  # Bright Black/Grey (adjust if needed)
        "sidebar_divider": c[0],  # Darkest grey
        # Modal
        "modal_cancel_fg": bg,
        "modal_cancel_bg": c[1],  # Red
        "modal_confirm_fg": bg,
        "modal_confirm_bg": c[4],  # Blue
        # Help Menu
        "help_menu_hotkey": c[6],  # Cyan
        "help_menu_title": c[5],  # Magenta
    }
    return theme_data


# --- Main script logic ---
if not os.path.exists(wal_colors_file):
    print(f"Error: Pywal colors file not found at {wal_colors_file}")
    exit(1)

try:
    with open(wal_colors_file, "r") as f:
        pywal_colors = json.load(f)

    superfile_theme = generate_theme(pywal_colors)

    # Ensure theme directory exists
    os.makedirs(os.path.dirname(output_theme_file), exist_ok=True)

    with open(output_theme_file, "w") as f:
        toml.dump(superfile_theme, f)

    print(f"Successfully generated superfile theme: {output_theme_file}")

except json.JSONDecodeError:
    print(f"Error: Could not decode JSON from {wal_colors_file}")
    exit(1)
except Exception as e:
    print(f"An error occurred: {e}")
    exit(1)
