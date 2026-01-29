#!/bin/bash

direction=$1

if [[ -z "$direction" ]]; then
  echo "Usage: $0 <left|right|up|down>"
  exit 1
fi

current_workspace=$(hyprctl activeworkspace -j | jq '.id')
current_monitor=$(hyprctl monitors -j | jq -c '.[] | select(.focused)')
current_monitor_name=$(echo "$current_monitor" | jq -r '.name')
current_x=$(echo "$current_monitor" | jq '.x')
current_y=$(echo "$current_monitor" | jq '.y')

# Correct abs emulation using parentheses inside object construction
target_monitor=$(hyprctl monitors -j | jq -c --arg dir "$direction" --argjson cx "$current_x" --argjson cy "$current_y" --arg cmn "$current_monitor_name" '
  map(select(.name != $cmn)) |
  map(. + {
    dx: (.x - $cx),
    dy: (.y - $cy),
    adx: ((.x - $cx) | if . < 0 then -1 * . else . end),
    ady: ((.y - $cy) | if . < 0 then -1 * . else . end)
  }) |
  map(select(
    ($dir == "left"  and .dx <  0 and .ady < .width) or
    ($dir == "right" and .dx >  0 and .ady < .width) or
    ($dir == "up"    and .dy <  0 and .adx < .height) or
    ($dir == "down"  and .dy >  0 and .adx < .height)
  )) |
  sort_by(if $dir == "left" or $dir == "right" then .adx else .ady end) |
  .[0]
')

if [[ -z "$target_monitor" || "$target_monitor" == "null" ]]; then
  echo "No monitor found in direction: $direction"
  exit 1
fi

target_name=$(echo "$target_monitor" | jq -r '.name')

hyprctl dispatch "hl.dsp.workspace.move({ workspace = '$current_workspace', monitor = '$target_name' })"

