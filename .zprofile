export ELECTRON_OZONE_PLATFORM_HINT=auto

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    exec sway --unsupported-gpu
fi
