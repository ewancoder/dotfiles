#!/usr/bin/env bash

while true; do
    if ! swaymsg -t get_tree | grep -q '"tilda"'; then
        echo "Spawning another tilda at $(date)" >> /tmp/ew-tilda.log
        foot -a foot_tilda -T Tilda -f monospace:size=12 &
        sleep 1
        swaymsg '[con_mark="tilda"]' resize set 3840 1080, move position 0 0
    fi
    sleep 10
done
