#!/usr/bin/env bash
while true; do
    lyrics="$(cat /tmp/lyrics)"
    sleep=0.2

    total_width=60
    left_part="$lyrics"
    left_width="${#left_part}"
    spaces_needed=$(( total_width - left_width ))

    [[ $spaces_needed -lt 1 ]] && spaces_needed=1
    spacer=$(printf "%*s" "$spaces_needed" "")

    echo "$left_part$spacer"
    sleep $sleep
done
