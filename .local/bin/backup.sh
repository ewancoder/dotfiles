#!/usr/bin/env bash
# Run this from root only always.
# HOSTNAMES should be unique to use this script.
# TODO: Consider also backing up to HDD.

if [ ! -d /mnt/backup/backups ]; then
    echo 'Skipping backup, /mnt/backup/backups is missing.'
    exit
fi

export $(cat /root/.secrets) || true # No secret for asgard for now.

# === SHARED ===
# ~/.gnupg and ~/.ssh folders, plus important security keys
rsync -av --delete /mnt/data/security/ /mnt/backup/backups/security
# Store weekly backups.
rsync -av --delete /mnt/data/security/ /mnt/backup/backups/security-weekly/security-$(date +%Y-W%U)
# Store online-security part without device-specific things.
rsync -av --delete /mnt/data/security/ /mnt/backup/backups/security-online --exclude='ssh' --exclude 'wg'
# Claude config backup (local only, not encrypted/uploaded)
# TODO: Enable first line if need to save Desktop app configs.
#rsync -av --delete /home/$USER/.config/Claude/ /home/$USER/projects/claude-backup/config-Claude
rsync -av --delete /home/$USER/.claude/ /mnt/backup/backups/claude-config

# === ODIN ===
# Unique data: media, photos, notes, everything that never should be lost
rsync -av --delete /mnt/data/unique/ /mnt/backup/backups/unique

# === ASGARD ===
# Development environment project data for TyR projects
rsync -av --delete /mnt/data/tyr/ /mnt/backup/backups/tyr
# Media server configuration (TyR Media)
rsync -av --delete /mnt/data/lab/configs/ /mnt/backup/backups/lab/configs --exclude='**/logs/**' --exclude '**/log/**' --exclude 'jellyfin/data/data/subtitles/**' --exclude 'jellyfin/cache'
rsync -av --delete /mnt/data/lab/backdrops/ /mnt/backup/backups/lab/backdrops
# T.Y.R.V.I.S. data files
rsync -av --delete /mnt/data/tyrvis/ /mnt/backup/backups/tyrvis

# Backup tyrm and security to shared storage
cd /mnt/backup/backups
tar -czpf "lab-configs-$(hostname).tar.gz" lab-configs
tar -czpf "security-$(hostname).tar.gz" security-online

# TODO: Only execute this on Odin (probably).
mkdir -p /tmp/crypt
echo $CRYPT_PASSWORD | gocryptfs /mnt/data/Dropbox/backups /tmp/crypt
mv *.tar.gz /tmp/crypt
chown -R $USER:$USER /tmp/crypt
fusermount -u /tmp/crypt
