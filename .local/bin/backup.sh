#!/usr/bin/env bash

rsync -av /mnt/data/media/configs/ /mnt/backup/backups/media-configs
rsync -av /mnt/data/seq/ /mnt/backup/backups/seq
rsync -av /mnt/data/unique/ /mnt/backup/backups/unique
