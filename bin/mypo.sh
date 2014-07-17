#!/bin/bash
if ! [ "$(ponymix --sink-input list)" == "" ]; then
    ponymix --sink-input list > temp.mypo
    apps="$(cat temp.mypo | awk '/sink/{getline;print}')"
    inds=$(cat temp.mypo | grep 'sink-input' | awk '{print $2}' | sed 's/://')
    vols=$(cat temp.mypo | grep 'Avg. Volume:' | awk '{print $3}' | sed 's/%//')
    echo $inds > /tmp/inds.mypo
    rm temp.mypo
    IFS=$'\r\n' GLOBIGNORE='*' :; app=($apps)
    IFS=$'\r\n' GLOBIGNORE='*' :; ind=($inds)
    IFS=$'\r\n' GLOBIGNORE='*' :; vol=($vols)
    for (( i = 0; i <= ${#apps[@]}; i++ )); do
        if ! [ "${ind[$i]}" == "" ]; then
            wmiir create /rbar/Audio${ind[$i]} &
            wmiir xwrite /rbar/Audio${ind[$i]} colors "#ada #046 #000"
            wmiir xwrite /rbar/Audio${ind[$i]} label "${app[$i]}: ${vol[$i]}" &
        fi
    done
else
    rm /tmp/inds.mypo
fi

current=$(wmiir ls /rbar | grep Audio | cut -c6-8)
IFS=$'\r\n' GLOBIGNORE='*' :; current=($(wmiir ls /rbar | grep Audio | cut -c6-8))
for i in $current; do
    if [ "$(echo $inds | grep $i)" == "" ] && ! [ "$i" == "" ]; then
        wmiir rm /rbar/Audio$i
    fi
done
