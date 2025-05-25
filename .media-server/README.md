# TyR Media Server


folder setup:
mkdir /mnt/data/tyrm
mkdir /mnt/hdd/data/tyrm/downloads
ln -s /mnt/hdd/data/tyrm/downloads /mnt/data/tyrm/downloads
mkdir /mnt/hdd/data/tyrm/media
ln -s /mnt/hdd/data/tyrm/media /mnt/data/tyrm/media

This is a media server for media library management.

## How to start

First, you need to edit environment variables in `.env` file:

1. `DOWNLOADS_FOLDER` - the folder where all the downloads will be kept.
2. `MEDIA_FOLDER` - the folder for all services configurations and data (handlinked media files, should be on the same SSD/HDD volume as downloads folder).
3. `HOSTNAME` - your PC hostname (or address you're going to use to access Homepage) - needed for Homepage to work
4. `VPN_WG_CONFIG` - configuration file for WireGuard to connect to PIA VPN

All the other variables are optional and fine-tuning your setup.

If you use other VPN provider this setup might not work for you.

### Tweak folder permissions

Make sure your user (1000) owns all folders created by docker volumes mounting:
`chown -R user:user FOLDER` (media/watches folder, the one where media files are stored for sonarr/readarr)

### VPN setup (for PIA wireguard)

`go install github.com/Ephemeral-Dust/pia-wg-config@latest`
`~/go/bin/pia-wg-config -r nl_amsterdam -o wg0.conf --server --port-forwarding PIA_LOGIN PIA_PASSWORD`

Then check out the wg0.conf file and set up the same region for `gluetun` region (in .env file).

## Setup

0. Test that VPN is working: Use HTTP proxy from browser to check your IP address.

(unnecessary - we have bind mounts now)
1. Copy yaml files (services.yaml, bookmarks.yaml) to your HOMEPAGE config folder. Then you can use your HOSTNAME to open Homepage and set everything up using the links there.

2. Set up qBitTorrent (initial password is in logs).

- Disable localhost authentication.
- Disable auth for `172.16.0.0/12` - docker IP ranges.
- Check port, restart EVERYTHING, check port again (should use PIA forwarded port, check in gluetun logs).

Behavior:
- Show external IP in status bar

Downloads:
- Excluded file names: `*.lnk`

Connection:
- Uncheck all connections limits

Speed:
- Alternative Rate Limits: 1000 upload, 3000 download

BitTorrent:
- Uncheck Torrent Queueing
- Seeding limits: When ratio reaches 2, seeding time reaches 10080 minutes (7 days), when inactive seeding time reaches 10080 minutes (7 days) - then STOP torrent (not delete)

Advanced:
- RAM limit: 12288 (12 Gb)
- Recheck torrents on completion (better integrity)

3. Set up: Sonarr, Radarr
- Authentication method: basic (admin, qwerty)
- Authentication required: Disable for localhost

Media Management:
- Add root folder

Profiles:
- Add everything to Any except BlueRays and top Raw-HD for movies and no br-disk too, just remuxes; upgrades allowed, until Bluray2160p Remux
- Add/edit BadTv quality: all except 4k (and also no Bluray-1080p Remux, and no Raw-HD or BR-DISK), upgrade until web 1080p
- Remove all other profiles
- Edit Delay profile: prefer Torrent
- (consider setting up release profiles later)

Indexers: just verify later after setting up Prowlarr

Download Clients:
- Add qBitTorrent: localhost:8080
- (consider, unchecked for now for faster downloads) Donload in sequential order, first and last first

Import Lists:
- (consider in future) adding trakt.tv lists integration

Connect:
- (consider, for now none):
  - discord/telegram/pushover/pushbullet
  - jellyfin
  - trakt

Metadata:
- (consider enabling some? for now not configured)

General:
- grab API key for future

UI: dark theme

4. Set up indexers: open Prowlarr, set up authentication (and do NOT require authentication for Localhost).
- Indexer proxy: flaresolverr: tags - flaresolverr
- Applications: Radarr, Sonarr
- (consider telegram/pushbullet notifications)
- ui: dark theme
- indexers: (make sure everything has priority 25, rutracker 20)
  - 1337.x, add flaresolverr tag
  - therarbg
  - kinozal.tv
  - rutracker (20 priority)
  - the pirate bay

- Click Sync App Indexers

6. Set up Jellyfin

- Create MY account
- Library: /data/movies + /data/downloads/manual-movies, /data/tvshows + /data/downloads/manual/shows
ALSO:
  - downloads/custom-media - home videos and photos

  - Preferred language: english
  - Country: USA
  - Automatically refresh metadata = 30 days
  - Metadata savers: Nfo
  - Save artwork
  - !! leave trickplay off for now - less cpu/gpu load when importing and i don't really need it.
  - !! And leave chapter images off too - lets see how it goes
  - automerge series from different folders

- English/United States
- Uncheck allow remote connections

go to dashboard - general - login disclaimer :) and styles

(THE REST OF SETTINGS CAN WAIT TILL I SET UP JELLYSEERR)

Manage:
Settings:
- screensaver: backdrop
- backdrops, theme songs, theme videos
- enable rewatching in next up
- use episode images in nextup/continue
- Section 1: continue watching
- Section 2: My Media
(everything else - none)
- Library order: Shows, Movies, Home
Playback:
- Preferred language - english
- Uncheck play default audio track
- Uncheck set audio track based on previous
- Uncheck same for subtitles
Subtitles:
- English
- Always play
- Smaller size
- Text color: Grey

Dashboard:
General: login disclaimer :)
Enable splash screen

Hardware transcoding: nvenc + enable ALL formats and even tone mapping
trickplay - enable hardware decoding

install trakt plugin: restart container
- uncheck EVERYTHING except scrobble

add 2 more users: family, nataliya (configure them the same as above for user on pc)
---- also configure on TV later
-- allow access to all libraries, allow to manage server/collections/subtitles
-- allow everything basically, even control of users why not

- todo: log in to each user set up english/usa (lazy for now)
-- do this on tv as well

6. Jellyseer (connect to sonarr/radarr and jellyfin)
- Configure jellyfin & Radarr & Sonarr, check Enable Scan too, and check default server
- Any (best) quality profile by default
- import users from jellyfin (AFTER setting up jellyfin users) ?? maybe not necessary now, some feature might allow sign in of jellyfin users
- todo: set up, lazy for now
- !. request something (movie & tv show) and see that it works

todo: set up kavita
- sign up / sign in with my account
