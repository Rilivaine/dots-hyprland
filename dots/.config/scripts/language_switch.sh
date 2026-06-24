#!/usr/bin/env sh

scrDir=$(dirname "$(realpath "$0")")
source "$scrDir/common.sh"

hyprctl switchxkblayout all next

# layMain=$(hyprctl -j devices | jq -r '.keyboards[] | select(.main == true) | .active_keymap')

# notify_single -t 800 -i "$HOME/.config/dunst/icons/keyboard.svg" "$layMain"
