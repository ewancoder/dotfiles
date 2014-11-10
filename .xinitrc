#!/bin/sh
#This file is executed by startx (not DM)
#All lines placed here are automatically executed by DM

#Execute all system scripts
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

#Source .xprofile
. ~/.xprofile

#Start pulseaudio
pulseaudio --start &

#Execute my WM
exec wmii
