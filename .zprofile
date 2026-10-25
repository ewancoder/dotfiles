# Same env as systemd user units get (see the file for details).
set -a; source ~/.config/environment.d/10-session.conf; set +a

# Start ssh-agent
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [ ! -f "$SSH_AUTH_SOCK" ]; then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi

if [[ -z "$WAYLAND_DISPLAY" ]] && [[ "$(tty)" = "/dev/tty1" ]]; then
    export WLR_RENDERER=vulkan # More performant, native Vulkan renderer. Sway doesn't hog CPU.
    #export WLR_RENDERER=gles2 # Waits for each frame, more robust - less performant.
    #export __GL_YIELD=USLEEP # Do not spin CPU when GPU is waiting for it. Only makes sense for gles2 renderer, XPlane uses native Vulkan. Other apps are better responsive over CPU use.
    #export WLR_NO_HARDWARE_CURSORS=1 # Hardware cursors make vulkan sunshine stream flicker a lot when Game is in focus.
    # We also might need direct scanout (not disabled) for XPlane to NOT stutter Sway, when it uses ALL of GPU (with lsfg-vk off).
    #export WLR_SCENE_DISABLE_DIRECT_SCANOUT=1 # Fixes xfreerdp scrambling. BUT causes each frame to be copied to Sway before sending to monitor.
    # Log sway (errors only at the default level) to a per-session file instead of tty1; keep the last 10.
    swaylogs=~/.local/state/sway; mkdir -p $swaylogs
    rm -f -- $swaylogs/sway-*.log(Nom[10,-1]) # N: no error if none; om: newest first
    exec sway --unsupported-gpu > $swaylogs/sway-$(date +%Y%m%d-%H%M%S).log 2>&1
fi
