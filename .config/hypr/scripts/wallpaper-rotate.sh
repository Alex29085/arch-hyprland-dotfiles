#!/usr/bin/env bash
DIR="$HOME/Pictures/Wallpapers"

while ! awww query >/dev/null 2>&1; do
    sleep 1
done

while true; do
    mapfile -d '' WALLPAPERS < <(
        find "$DIR" -type f \
        \( -iname '*.jpg' -o -iname '*.jpeg' \
        -o -iname '*.png' -o -iname '*.webp' \) \
        -print0 | shuf -z
    )

    if [ "${#WALLPAPERS[@]}" -eq 0 ]; then
        sleep 60
        continue
    fi

    for WALL in "${WALLPAPERS[@]}"; do
        awww img "$WALL" --transition-type fade --transition-duration 2
        sleep 900
    done
done
