#!/bin/bash

# $1 = number [ 0, 1, 2 ]
# $2 = sink-input [ 42, 37, ... ]

ponymix --sink-input list > /tmp/temp.mypo

IFS=$'\r\n' GLOBIGNORE='*' :; app=($(cat /tmp/temp.mypo | awk '/sink/{getline;print $1}'))
IFS=$'\r\n' GLOBIGNORE='*' :; vol=($(cat /tmp/temp.mypo | grep 'Avg. Volume:' | awk '{print $3}' | sed 's/%//'))

wmiir xwrite /rbar/Audio$2 label "${app[$1]}: ${vol[$1]}" &
