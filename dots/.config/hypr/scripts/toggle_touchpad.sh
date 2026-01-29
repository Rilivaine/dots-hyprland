#!/usr/bin/env bash
# toggle-touchpad.sh — toggle your touchpad on Wayland/Hyprland

# Path to store current enable/disable state
STATUS_FILE="$XDG_RUNTIME_DIR/touchpad.status"
: "${STATUS_FILE:="$(printf '%s/touchpad.status' "$XDG_RUNTIME_DIR")"}"

scrDir=$(dirname "$(realpath "$0")")
source "$scrDir/common.sh"

# Detect touchpad via hyprctl devices
device=$(hyprctl devices | grep -F touchpad | head -n1 | awk '{print $1}')
if [[ -z "$device" ]]; then
  echo "⚠️ No touchpad found via hyprctl"
  exit 1
fi

# Initialise state file if missing
if [[ ! -f "$STATUS_FILE" ]]; then
  echo "enabled" > "$STATUS_FILE"
fi

# Read and toggle
if [[ "$(cat "$STATUS_FILE")" == "enabled" ]]; then
  new_state="false"
  echo "disabled" > "$STATUS_FILE"
else
  new_state="true"
  echo "enabled" > "$STATUS_FILE"
fi

# Apply toggle and force Hyprland to refresh
hyprctl keyword "device[$device]:enabled" "$new_state"

# Optional notification if you use mako/notify
if command -v notify-send &>/dev/null; then
  if [[ "$new_state" == "true" ]]; then
    notify_single -u normal "Touchpad enabled"
  else
    notify_single -u normal "Touchpad disabled"
  fi
fi


