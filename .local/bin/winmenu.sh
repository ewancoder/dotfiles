#!/usr/bin/env bash
set -euo pipefail

sel=$(swaymsg -t get_tree | jq -r '
  .. | objects | select(.type == "workspace") | .name as $ws |
  [recurse(.nodes[]?, .floating_nodes[]?)] | .[] |
  select(.app_id != null or .window_properties.class != null) |
  "\(.id)\t\($ws)  ·  \(.app_id // .window_properties.class)  ·  \(.name)"
' | fuzzel --dmenu --with-nth 2 -w 120 --background "1a3a5add") || exit 0

[ -n "$sel" ] || exit 0
swaymsg "[con_id=${sel%%$'\t'*}] focus"
