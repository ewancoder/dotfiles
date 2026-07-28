#!/usr/bin/env bash
set -euo pipefail
# ---------------- config ----------------
BROWSER=(zen-browser)
TERMINAL=(foot)                 # --working-directory/--title below are foot syntax
EDITOR=(code -n)
SHELL_BIN="${SHELL:-/usr/bin/zsh}"
CLAUDE_CMD='claude --continue || claude'
PROJECTS_DIR="${PROJECTS_DIR:-$HOME/projects}"
PROJECTS_MAXDEPTH="${PROJECTS_MAXDEPTH:-3}"
TERM_PPT="${TERM_PPT:-20}"      # each terminal's share of the right column
BROWSER_PPT="${BROWSER_PPT:-50}"
# ----------------------------------------
die() { printf '%s\n' "$*" >&2; exit 1; }
sw()  { swaymsg -- "$@" >/dev/null; }
win_count() {
  swaymsg -t get_tree \
    | jq '[recurse(.nodes[]?, .floating_nodes[]?) | select(.pid != null)] | length'
}
# launch <mark> <command...>
launch() {
  local mark=$1; shift
  local cmd before tries=300
  printf -v cmd '%q ' "$@"
  before=$(win_count)
  swaymsg exec -- "$cmd" >/dev/null
  while (( tries-- > 0 )); do
    (( $(win_count) > before )) && { sleep 0.15; sw "mark --add $mark"; return 0; }
    sleep 0.1
  done
  die "timed out waiting for window: $*"
}
pick_workspace() {
  command -v zenity >/dev/null || die "zenity not found"
  zenity --entry --title='Sway layout' --text='Workspace name:' 2>/dev/null
}
pick_dir() {
  command -v fuzzel >/dev/null || die "fuzzel not found"
  local list rel
  list=$(
    find -H "$PROJECTS_DIR" -mindepth 1 -maxdepth "$PROJECTS_MAXDEPTH" \
      \( -name .git -o -name node_modules -o -name .venv \
         -o -name bin -o -name obj -o -name target \) -prune -o \
      -type d -printf '%P\n' | sort
  )
  [[ -n $list ]] || die "no directories under $PROJECTS_DIR"
  rel=$(printf '%s\n' "$list" \
        | fuzzel --dmenu --no-exit-on-keyboard-focus-loss \
                 --cache=/dev/null --prompt='project> ') || return 1
  [[ -n $rel ]] && printf '%s/%s\n' "$PROJECTS_DIR" "$rel"
}
# ---------------- args ----------------
if (( $# == 0 )); then
  WS=$(pick_workspace) || exit 0
  [[ -n ${WS//[[:space:]]/} ]] || exit 0
  DIR=$(pick_dir) || exit 0
  [[ -n $DIR ]] || exit 0
else
  WS=$1
  DIR=${2:-$PWD}
fi
DIR=$(realpath -e -- "$DIR") || die "no such directory"
# already built? just go there
if swaymsg -t get_tree | jq --arg ws "$WS" -e '
      [ recurse(.nodes[]?, .floating_nodes[]?)
        | select(.type == "workspace" and .name == $ws) ] as $w
      | ($w | length) > 0
        and ([ $w[0] | recurse(.nodes[]?, .floating_nodes[]?)
               | select(.pid != null) ] | length) > 0' >/dev/null
then
  sw "workspace $WS"
  exit 0
fi
# ---------------- build ----------------
sw "workspace $WS"
launch _l_browser "${BROWSER[@]}"
sw "splith"
launch _l_git "${TERMINAL[@]}" \
  --working-directory="$DIR" --title="${WS}-git"
sw "splitv"
launch _l_code "${EDITOR[@]}" "$DIR"
launch _l_claude "${TERMINAL[@]}" \
  --working-directory="$DIR" --title="${WS}-claude" \
  "$SHELL_BIN" -ic "$CLAUDE_CMD; exec $SHELL_BIN"
# ---------------- size ----------------
sw '[con_mark="_l_browser"] focus'
sw "resize set width $BROWSER_PPT ppt"
for _ in 1 2; do                       # two passes to converge
  sw '[con_mark="_l_git"] focus';    sw "resize set height $TERM_PPT ppt"
  sw '[con_mark="_l_claude"] focus'; sw "resize set height $TERM_PPT ppt"
done
sw '[con_mark="_l_git"] focus'
for m in _l_browser _l_git _l_code _l_claude; do
  swaymsg "[con_mark=\"$m\"] unmark $m" >/dev/null
done
