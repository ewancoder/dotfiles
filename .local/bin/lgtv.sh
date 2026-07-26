#!/usr/bin/env bash
# lgc5 — control the LG C5 via bscpylgtv
#
# Usage:
#   lgc5 pc         # switch to PC (HDMI 1)
#   lgc5 jellyfin   # launch the Jellyfin app
#   lgc5 pause      # pause playback (Jellyfin/app mode)
#   lgc5 play       # resume playback
#   lgc5 wake       # send Wake-on-LAN magic packet only
#   lgc5 off        # power the panel off (screen off / standby)
#   lgc5 status     # dump current app + power state
#
# First run requires the TV to be on: you'll get a pairing prompt on the
# panel — accept it. The client key is stored in the KEYS path below
# (shared with your other bscpylgtv scripts).

set -euo pipefail

# --- config (override via env) ------------------------------------------------
TV_IP="${LGC5_IP:-192.168.1.152}"         # C5 IP (set a DHCP reservation)
TV_MAC="${LGC5_MAC:-30:34:DB:C7:D7:7A}"    # C5 MAC for WoL
KEYS="${LGC5_KEYS:-$HOME/.config/bscpylgtv-keys.sqlite}"  # client-key store
JELLYFIN_APP_ID="${LGC5_JELLYFIN_APP:-org.jellyfin.webos}"

BIN="bscpylgtvcommand"

# --- helpers ------------------------------------------------------------------
tv() { "$BIN" -p "$KEYS" "$TV_IP" "$@"; }

require_ip() {
  if [[ -z "$TV_IP" ]]; then
    echo "lgc5: set LGC5_IP (or edit TV_IP) to the C5's address" >&2; exit 2
  fi
}

require_mac() {
  if [[ ! "$TV_MAC" =~ ^([0-9A-Fa-f]{2}[:-]){5}[0-9A-Fa-f]{2}$ ]]; then
    echo "lgc5: set LGC5_MAC (or edit TV_MAC) to the C5's MAC, e.g. aa:bb:cc:dd:ee:ff" >&2
    exit 2
  fi
}

wol() {
  require_mac
  # pure-python magic packet — no extra deps beyond python3 (already pulled in
  # by bscpylgtv). Harmless no-op if the panel is already on.
  python3 - "$TV_MAC" <<'PY'
import socket, sys
mac = sys.argv[1].replace(":", "").replace("-", "")
data = bytes.fromhex("f" * 12 + mac * 16)
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
s.sendto(data, ("255.255.255.255", 9))
PY
}

# --- commands -----------------------------------------------------------------
case "${1:-}" in
  pc|jellyfin|pause|play|off|status) require_ip ;;
esac

case "${1:-}" in
  pc)        tv set_input HDMI_1 ;;
  jellyfin)  tv launch_app "$JELLYFIN_APP_ID" ;;
  pause)     tv button PAUSE ;;
  play)      tv button PLAY ;;
  wake)      wol ;;
  off)       tv power_off ;;
  status)    tv -o get_current_app_name 2>/dev/null || tv get_apps_all ;;
  *)
    echo "usage: lgc5 {pc|jellyfin|pause|play|wake|off|status}" >&2
    exit 1
    ;;
esac
