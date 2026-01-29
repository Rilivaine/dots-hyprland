#!/usr/bin/env bash

# Usage: zoom.sh [in|out|reset]
# Example: zoom.sh in

get_zoom() {
  hyprctl getoption cursor:zoom_factor -j | jq -r '.float'
}

set_zoom() {
  local new_zoom=$1
  hyprctl -q keyword cursor:zoom_factor "$new_zoom"
}

current=$(get_zoom)

case "$1" in
in)
  new=$(awk -v c="$current" 'BEGIN {print (c >= 3.0 ? 3.0 : c + 0.5)}')
  ;;
out)
  new=$(awk -v c="$current" 'BEGIN {print (c <= 1.0 ? 1.0 : c - 0.5)}')
  ;;
reset)
  new=1.0
  ;;
*)
  echo "Usage: $0 [in|out|reset]"
  exit 1
  ;;
esac

set_zoom "$new"
echo "Zoom set to $new"
