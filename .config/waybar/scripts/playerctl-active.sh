#!/usr/bin/env bash
set -u

# Prefer a currently playing player.
while IFS= read -r player; do
    if [[ "$(playerctl --player="$player" status 2>/dev/null)" == "Playing" ]]; then
        printf '%s\n' "$player"
        exit 0
    fi
done < <(playerctl -l 2>/dev/null)

# Otherwise use the first available player.
playerctl -l 2>/dev/null | head -n 1
