# Arch Linux + Hyprland Dotfiles

Personal Arch Linux desktop configuration built around Hyprland, Quickshell,
Waybar, Rofi and Kitty.

## Features

- Minimal monochrome graphite theme
- Quickshell panels and system settings
- Waybar status bar and media controls
- Rofi application launcher
- Dynamic colors and theme presets
- Wallpaper selection and rotation using awww
- Hyprlock and Hypridle configuration

## Requirements

- Arch Linux
- Internet access and sudo privileges
- A backup of your current configuration

## Installation

Clone the repository:

    git clone https://github.com/Alex29085/arch-hyprland-dotfiles.git
    cd arch-hyprland-dotfiles

Review `install.sh` before running it.

The installer uses `pacman -Syu`, which updates the system as well as
installing required packages. It then backs up the selected configuration
paths and asks for confirmation before replacing them.

**Warning:** selected directories under `~/.config` are replaced, not merged.
Back up your existing files and review the script before proceeding.

The installer does not copy wallpapers, generate a theme, or restart Hyprland.

## Wallpapers

Place wallpaper images in `~/Pictures/Wallpapers`.

## Customization

Review `.config/hypr`, `.config/waybar`, `.config/quickshell`,
`.config/rofi` and `.config/43pr` before making changes.

## Credits

This setup incorporates and adapts components from
[43PR/dotfiles](https://github.com/43PR/dotfiles).
Check upstream licensing and attribution requirements before redistributing
upstream-derived files.
