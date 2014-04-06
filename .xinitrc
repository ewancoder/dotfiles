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
xset +fp /usr/share/fonts/local &
start-pulseaudio-x11 &
pasystray &
/usr/bin/screen -dmS ircscr irssi &
xcompmgr &
devilspie -a &
xset -dpms s off

exec wmii
