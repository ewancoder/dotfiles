#!/bin/bash

cd /home/ewancoder/projects/claude-init
while true; do claude -p "Reply with exactly: ok" --model claude-haiku-4-5-20251001 && sleep 600; done
