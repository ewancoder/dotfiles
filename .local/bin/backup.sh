#!/usr/bin/env bash

rsync -av --delete /mnt/data/media/configs/ /mnt/backup/backups/media-configs
rsync -av --delete /mnt/data/seq/ /mnt/backup/backups/seq
rsync -av --delete /mnt/data/unique/ /mnt/backup/backups/unique

rsync -av --delete /mnt/data/media/configs/ /mnt/hdd/backups/media-configs
rsync -av --delete /mnt/data/seq/ /mnt/hdd/backups/seq
rsync -av --delete /mnt/data/unique/ /mnt/hdd/backups/unique
