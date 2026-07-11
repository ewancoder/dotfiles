#!/bin/bash
KEYS=/home/ewancoder/.config/bscpylgtv-keys.sqlite
TV=192.168.1.152

APP=$(bscpylgtvcommand -p "$KEYS" "$TV" get_current_app 2>/dev/null)

case "$APP" in
    *com.webos.app.hdmi*)
        bscpylgtvcommand -p "$KEYS" "$TV" power_off
        ;;
    *)
        # In an app (Jellyfin etc.) or unreachable — do nothing
        ;;
esac
