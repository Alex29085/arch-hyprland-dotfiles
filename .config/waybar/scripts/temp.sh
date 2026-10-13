#!/usr/bin/env bash
for d in /sys/class/hwmon/hwmon*; do
    [[ -r "$d/name" ]] || continue
    [[ "$(<"$d/name")" == "k10temp" ]] || continue
    read -r t < "$d/temp1_input"
    awk -v t="$t" 'BEGIN {printf "{\"text\":\"CPU TEMP %.1f°C\"}\n",t/1000}'
    exit
done
printf '{"text":"TEMP —"}\n'
