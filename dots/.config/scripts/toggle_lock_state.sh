#!/usr/bin/env bash

STATE_DIR="/tmp/$USER"
STATE_FILE="$STATE_DIR/lock_states.json"

mkdir -p "$STATE_DIR"
touch "$STATE_FILE"

get_keyboard() {
  hyprctl devices -j | jq -r '.keyboards[] | select(.name | test("^at-translated-set"))'
}

read_lock_states() {
    keyboard=$(get_keyboard)

    if [ -z "$keyboard" ]; then
        echo "No keyboard data found." >&2
        return 1
    fi

    caps_state=$(echo "$keyboard" | jq '.capsLock // false')
    num_state=$(echo "$keyboard" | jq '.numLock // false')
}

get_state() {
    read_lock_states || exit 1
    echo "{\"capsLock\": $caps_state, \"numLock\": $num_state}" > "$STATE_FILE"
}

set_state() {
    if ! jq empty "$STATE_FILE" >/dev/null 2>&1; then
        echo "Invalid or empty state file."
        exit 1
    fi

    capslock=$(jq '.capsLock' "$STATE_FILE")
    numlock=$(jq '.numLock' "$STATE_FILE")

    read_lock_states || exit 1

    [ "$capslock" != "$caps_state" ] && wtype -k Caps_Lock
    [ "$numlock" != "$num_state" ] && wtype -k Num_Lock
}

case "$1" in
    save)
        get_state
        ;;
    load)
        set_state
        ;;
    *)
        echo "Usage: $0 {save|load}"
        ;;
esac

