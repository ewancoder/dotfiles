#!/bin/bash

sleep 10
CONTAINER_NAME="tyr-media-jellyfin"

while true; do
    STATUS=$(docker inspect -f '{{.State.Running}}' "$CONTAINER_NAME" 2>/dev/null)
    if [ "$STATUS" == "true" ]; then
        echo "Jellyfin container is running."
        break
    fi
    sleep 1
done
sleep 10
jellyfin-mpv-shim --no-http &

