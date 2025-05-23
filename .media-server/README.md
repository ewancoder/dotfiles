# TyR Media Server

This is a media server for media library management.

## How to start

First, you need to edit environment variables in `.env` file:

1. `DOWNLOADS_FOLDER` - the folder where all the downloads will be kept.
2. `MEDIA_FOLDER` - the folder for all services configurations and data (handlinked media files, should be on the same SSD/HDD volume as downloads folder).
3. `HOSTNAME` - your PC hostname (or address you're going to use to access Homepage) - needed for Homepage to work
4. `VPN_WG_CONFIG` - configuration file for WireGuard to connect to PIA VPN

All the other variables are optional and fine-tuning your setup.

If you use other VPN provider this setup might not work for you.

