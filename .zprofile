export ELECTRON_OZONE_PLATFORM_HINT=auto
source ~/.secrets

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    exec sway --unsupported-gpu
fi
