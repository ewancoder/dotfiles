#!/usr/bin/env bash
# Run this from root only always.
# HOSTNAMES should be unique to use this script.
export $(cat /root/.secrets)

rsync -av --delete /mnt/data/unique/ /mnt/backup/backups/unique
rsync -av --delete /mnt/data/tyrm/configs/ /mnt/backup/backups/tyrm-configs
rsync -av --delete /mnt/data/tyr/ /mnt/backup/backups/tyr

rsync -av --delete /mnt/data/unique/ /mnt/hdd/backups/unique
rsync -av --delete /mnt/data/tyrm/configs/ /mnt/hdd/backups/tyrm-configs
rsync -av --delete /mnt/data/tyr/ /mnt/backup/backups/tyr

# ~/.gnupg and ~/.ssh folders, plus security keys
rsync -av --delete /mnt/data/security/ /mnt/backup/backups/security
rsync -av --delete /mnt/data/security/ /mnt/hdd/backups/security

# Backup tyrm configs
cd /mnt/backup/backups
rsync -av --delete /mnt/data/tyrm/configs/ /mnt/backup/backups/tyrm-configs-archive
find tyrm-configs-archive -type d -name "logs" | xargs rm -r
find tyrm-configs-archive -type d -name "log" | xargs rm -r
rm -r "tyrm-configs-archive/jellyfin/data/data/subtitles"
tar -czpf "tyrm-configs-$(hostname).tar.gz" tyrm-configs-archive

# Backup security
cd /mnt/backup/backups
rsync -av --delete /mnt/data/security/ /mnt/backup/backups/security-archive
tar -czpf "security-$(hostname).tar.gz" security-archive

# Backup to shared storage
chown ewancoder:ewancoder *.tar.gz
source /home/ewancoder/.secrets
mkdir -p /tmp/crypt
echo $CRYPT_PASSWORD | gocryptfs /mnt/data/Dropbox/backups /tmp/crypt
cp *.tar.gz /tmp/crypt
fusermount -u /tmp/crypt
