#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

xrdb -merge ~/.Xresources &
start-pulseaudio-x11 &
compton --backend glx --paint-on-overlay --vsync opengl-swc &
devilspie &
xset -dpms s off
unclutter -grab &

exec wmii
