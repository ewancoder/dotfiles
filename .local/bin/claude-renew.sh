#!/bin/bash

cd /home/ewancoder/projects/claude-init

sleep 60

while true; do
    if ! ~/.local/bin/claude -p "Reply with exactly: ok" --model claude-haiku-4-5-20251001; then
        notify-send "claude-renew failed"
    fi
    sleep 600
done
