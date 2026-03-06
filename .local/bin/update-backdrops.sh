#!/usr/bin/env bash

# Sync Jellyfin backdrop images to a flat screensaver folder.
rsync -avz --delete asgard:/mnt/data/tyrm/screensaver/ /mnt/data/tyrm/screensaver/
