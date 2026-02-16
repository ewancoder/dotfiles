#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="/mnt/data/tyrm/screensaver"
INTERVAL=600 # 10 minutes

while true; do
    wallpaper=$(find "$WALLPAPER_DIR/" -type f -name '*.jpg' -o -name '*.png' -o -name '*.webp' | shuf -n 1)
    swaymsg "output * bg '$wallpaper' fill"
    sleep "$INTERVAL"
done
