#!/bin/bash
if ! [ "$(ponymix --sink-input list)" == "" ]; then
    ponymix --sink-input list > /tmp/temp.mypo
    apps="$(cat /tmp/temp.mypo | awk '/sink/{getline;print $1}')"
    inds=$(cat /tmp/temp.mypo | grep 'sink-input' | awk '{print $2}' | sed 's/://')
    vols=$(cat /tmp/temp.mypo | grep 'Avg. Volume:' | awk '{print $3}' | sed 's/%//')
    echo $inds > /tmp/inds.mypo
    rm /tmp/temp.mypo
    IFS=$'\r\n' GLOBIGNORE='*' :; app=($apps)
    IFS=$'\r\n' GLOBIGNORE='*' :; ind=($inds)
    IFS=$'\r\n' GLOBIGNORE='*' :; vol=($vols)
    for (( i = 0; i < ${#app[@]}; i++ )); do
        if ! [ "${ind[$i]}" == "" ]; then
            wmiir create /rbar/Audio${ind[$i]} &
            wmiir xwrite /rbar/Audio${ind[$i]} colors "#ada #046 #000"
            wmiir xwrite /rbar/Audio${ind[$i]} label "${app[$i]}: ${vol[$i]}" &
        fi
    done
else
    rm /tmp/inds.mypo
fi

IFS=$'\r\n' GLOBIGNORE='*' :; current=($(wmiir ls /rbar | grep Audio | cut -c6-8))
for i in $current; do
    if [ "$(echo $inds | grep $i)" == "" ] && ! [ "$i" == "" ]; then
        wmiir rm /rbar/Audio$i
    fi
done
