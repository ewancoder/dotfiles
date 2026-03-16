#!/usr/bin/env bash

# Sync Jellyfin backdrop images to a flat screensaver folder.
rsync -avz --delete asgard-cron:/data/lab/backdrops/ /mnt/data/backdrops/
