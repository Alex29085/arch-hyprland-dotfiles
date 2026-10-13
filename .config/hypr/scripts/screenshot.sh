#!/usr/bin/env bash
set -euo pipefail

DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"
FILE="$DIR/$(date +'%Y-%m-%d_%H-%M-%S').png"

case "${1:-area}" in
  full)
    grim "$FILE"
    ;;
  area)
    GEOMETRY="$(slurp)" || exit 0
    grim -g "$GEOMETRY" "$FILE"
    ;;
  window)
    GEOMETRY="$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])')" 
    grim -g "$GEOMETRY" "$FILE"
    ;;
  copy)
    GEOMETRY="$(slurp)" || exit 0
    grim -g "$GEOMETRY" - | wl-copy
    exit 0
    ;;
esac
