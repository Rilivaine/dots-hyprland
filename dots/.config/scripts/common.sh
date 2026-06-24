#!/bin/bash
# ========== EXPORT ==========
export CFG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

# ========== CONFIG ==========
LOG_FILE="${HOME}/.HypraBreeze.log"

# ============================

# --- Logging ---
log() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    local app_name="$1"
    shift
    local message="$*"
    
    if [ -n "$app_name" ]; then
        echo "[$timestamp] [$app_name] $message" >> "$LOG_FILE"
    else
        echo "[$timestamp] $message" >> "$LOG_FILE"
    fi
}

# --- Notifications ---
notify() {
    # Persistent (shown & logged)
    local msg="$1"
    notify-send -u normal "$msg"
    log "Notification" "$msg"
}

notify_temp() {
    # Transient (shown but not logged)
    notify-send -h int:transient:1 "$@"
}

NOTIFY_ID_FILE="/tmp/notify_single_${USER}.id"

notify_single() {
    local id=0

    # Read previous ID if file exists
    if [[ -f "$NOTIFY_ID_FILE" ]]; then
        id=$(<"$NOTIFY_ID_FILE")
    fi

    # Send notification and get new ID
    id=$(notify_temp -p -r "$id" "$@")

    # Save new ID back to file
    echo "$id" > "$NOTIFY_ID_FILE"
}

pkg_installed() {
    local pkgIn=$1

    if pacman -Qi "$pkgIn" &>/dev/null; then
        return 0
    elif command -v flatpak &>/dev/null && flatpak info "$pkgIn" &>/dev/null; then
        return 0
    elif command -v "$pkgIn" &>/dev/null; then
        return 0
    fi

    return 1
}

AUR_HELPERS=(yay paru trizen pikaur)

get_aurhlpr() {
    for helper in "${AUR_HELPERS[@]}"; do
        if pkg_installed "$helper"; then
            echo "$helper"
            return
        fi
    done
}
