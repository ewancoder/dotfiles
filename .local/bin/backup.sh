#!/usr/bin/env bash
# Run this from root only always.
# HOSTNAMES should be unique to use this script.
export $(cat /root/.secrets)

# TODO: Also backup to /mnt/hdd when it's present.

# Unique data: media, photos, notes, everything that never should be lost
rsync -av --delete /mnt/data/unique/ /mnt/backup/backups/unique

# ~/.gnupg and ~/.ssh folders, plus important security keys
rsync -av --delete /mnt/data/security/ /mnt/backup/backups/security

# Development environment project data for TyR projects
rsync -av --delete /mnt/data/tyr/ /mnt/backup/backups/tyr

# Media server configuration (TyR Media)
rsync -av --delete /mnt/data/tyrm/configs/ /mnt/backup/backups/tyrm-configs --exclude='**/logs/**' --exclude '**/log/**' --exclude 'jellyfin/data/data/subtitles/**'
# tyrm/downloads - should be mounted to HDD / big storage
# tyrm/media - should also be mounted to the SAME HDD (for hardlinks)

# Backup tyrm and security to shared storage
cd /mnt/backup/backups
tar -czpf "tyrm-configs-$(hostname).tar.gz" tyrm-configs
tar -czpf "security-$(hostname).tar.gz" security

mkdir -p /tmp/crypt
echo $CRYPT_PASSWORD | gocryptfs /mnt/data/Dropbox/backups /tmp/crypt
mv *.tar.gz /tmp/crypt
chown -R ewancoder:ewancoder /tmp/crypt
fusermount -u /tmp/crypt
