#!/usr/bin/env bash
for f in /sys/class/drm/card*/device/gpu_busy_percent; do
    if [[ -r "$f" ]]; then
        read -r n < "$f"
        printf '{"text":"GPU %s%%"}\n' "$n"
        exit
    fi
done
printf '{"text":"GPU —"}\n'
