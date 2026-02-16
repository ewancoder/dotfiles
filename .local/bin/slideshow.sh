#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="/mnt/data/tyrm/screensaver"
INTERVAL=600 # 10 minutes

while true; do
    outputs=($(swaymsg -t get_outputs | jq -r '.[].name'))
    for output in "${outputs[@]}"; do
        wallpaper=$(find "$WALLPAPER_DIR/" -type f -name '*.jpg' -o -name '*.png' -o -name '*.webp' | shuf -n 1)
        echo $output
        swaymsg "output $output bg '$wallpaper' fill"
    done
    sleep "$INTERVAL"
done
