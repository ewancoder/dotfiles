export ELECTRON_OZONE_PLATFORM_HINT=auto
source ~/.secrets
export GPG_TTY=$(tty) # We need this for console GPG.

# Start ssh-agent
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [ ! -f "$SSH_AUTH_SOCK" ]; then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    exec sway --unsupported-gpu
fi
