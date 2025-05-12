#!/usr/bin/env bash
while true; do
    if [[ -f /tmp/lyrics ]]; then
        lyrics="$(cat /tmp/lyrics)"
    fi
    sensors="$(sensors | grep 'Core 0' | awk '{print $3}')"
    date="$(date)"
    netstats="$(cat /tmp/netstats)"
    volume="$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}')"
    speedLimitsStatus="$(curl -s http://localhost:8080/api/v2/transfer/speedLimitsMode)"
    if [ "$speedLimitsStatus" = "1" ]; then
        speedLimits=$'\U0001F422'
    else
        speedLimits=''
    fi
    sleep=0.2

    total_width=150
    left_part="$lyrics"
    right_part="$speedLimits $netstats    🔊 $volume   $sensors   $date"

    left_width="${#left_part}"
    right_width="${#right_part}"
    spaces_needed=$(( total_width - left_width - right_width ))

    [[ $spaces_needed -lt 1 ]] && spaces_needed=1
    spacer=$(printf "%*s" "$spaces_needed" "")

    echo "$left_part$spacer$right_part"
    sleep $sleep
done
