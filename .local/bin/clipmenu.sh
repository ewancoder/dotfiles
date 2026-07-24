#!/usr/bin/env bash
set -euo pipefail

sel=$(cliphist list | fuzzel --dmenu --with-nth 2 -w 120 --background "3a1a1add" ) || exit 0
[ -n "$sel" ] || exit 0

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
printf '%s\n' "$sel" | cliphist decode > "$tmp"
wl-copy --type "$(file -b --mime-type "$tmp")" < "$tmp"
