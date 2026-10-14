#!/usr/bin/env bash
# Replace "random" with: fade, wipe, grow, outer, wave, center, any, random

img="$1"
[[ -f "$img" ]] || { echo "commands.sh: not a file: $img" >&2; exit 1; }

awww img "$img" -t random --transition-duration 1

mkdir -p "$HOME/.cache/personal-theme"
setsid -f python3 "$HOME/.config/personal-theme/bin/theme.py" wallpaper "$img" \
    >>"$HOME/.cache/personal-theme/theme.log" 2>&1
