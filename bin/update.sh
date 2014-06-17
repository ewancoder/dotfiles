#!/bin/bash
if ! [ "$(yaourt -Qu)" == "" ]; then
    notify-send -t 30 -u low "New updates ($(yaourt -Qu | wc -l))" "$(yaourt -Qu)"
fi
