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

#These needed to be startuped at login, not at startx
devmon --exec-on-drive 'notify-send "Drive mounted" "Mounted %l on %d"' --exec-on-unmount 'notify-send "Drive unmounted" "Unmounted %l"' --exec-on-remove 'notify-send "Drive removed" "Removed %l"' &
find ~/Dropbox/Cute -type f | shuf -n 1 | xargs -I{} cp {} ~/Dropbox/Public/today.jpg &

#And these is just standart X configuration
xrdb -merge ~/.Xresources &
start-pulseaudio-x11 &
compton --backend glx --paint-on-overlay --vsync opengl-swc &
devilspie &
xset -dpms s off
unclutter -grab &

exec wmii
