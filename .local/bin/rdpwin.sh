#!/bin/bash
# RDP to the Windows box. Launched from RdpWin.desktop.
set -u

host="192.168.1.185"
mac="c8:cb:9e:90:77:75"
user="izyranau"
share="/mnt/data/rdp"
title="rdpwin"
log="${XDG_STATE_HOME:-$HOME/.local/state}/rdpwin.log"

fail() { notify-send -u critical -a rdpwin "RDP" "$1"; exit 1; }

# One instance only: a second launch focuses the running session.
exec 9>"${XDG_RUNTIME_DIR:-/tmp}/rdpwin.lock"
if ! flock -n 9; then
    swaymsg "[title=\"^$title\"] focus" >/dev/null 2>&1
    exit 0
fi

# Saved password next to the script; prompt only when it's missing or empty.
secret="$(dirname "$(readlink -f "$0")")/.rdpsecret"
pass=$(cat "$secret" 2>/dev/null)
if [[ -z $pass ]]; then
    pass=$(zenity --password --title="RDP $user@$host") || exit 0  # cancelled
    [[ -n $pass ]] || exit 0
fi

mkdir -p "$share" "${log%/*}"

# Wake the box in case it sleeps; freerdp's 15 s connect timeout covers the wake-up.
wol "$mac" >/dev/null 2>&1

# Defaults left out on purpose: compression, clipboard and fonts are on already; GFX implies 32 bpp.
# FreeRDP masks /p: in the process cmdline right after parsing.
start=$SECONDS
sdl-freerdp3 \
    /v:"$host" /u:"$user" /d:'' /p:"$pass" \
    /cert:ignore /auth-pkg-list:'!kerberos' \
    /t:"$title" \
    /gfx:progressive /dynamic-resolution \
    /audio-mode:0 \
    /drive:linux,"$share" \
    +auto-reconnect \
    >"$log" 2>&1
rc=$?
unset pass

# A quick exit means the connection never came up (bad password, NLA, ...). Closing a session normally isn't an error.
if (( rc != 0 && SECONDS - start < 15 )); then
    fail "Connection failed (exit $rc). Log: $log"
fi
