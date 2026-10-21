export ELECTRON_OZONE_PLATFORM_HINT=auto

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
    export WLR_SCENE_DISABLE_DIRECT_SCANOUT=1 # Fixes xfreerdp scrambling.
    exec sway --unsupported-gpu
fi
