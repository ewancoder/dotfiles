#!/usr/bin/env bash
while true; do
    lyrics="$(cat /tmp/lyrics)"
    sensors="$(sensors | grep 'Core 0' | awk '{print $3}')"
    date="$(date)"
    sleep=0.2

    total_width=120
    left_part="$lyrics"
    right_part="$sensors    $date"

    left_width="${#left_part}"
    right_width="${#right_part}"
    spaces_needed=$(( total_width - left_width - right_width ))

    [[ $spaces_needed -lt 1 ]] && spaces_needed=1
    spacer=$(printf "%*s" "$spaces_needed" "")

    echo "$left_part$spacer$right_part"
    sleep $sleep
done
