#!/usr/bin/env sh

# Source global control script
scrDir=$(dirname "$(realpath "$0")")
source "$scrDir/common.sh"

# Check if SwayOSD is installed
use_swayosd=false
if command -v swayosd-client >/dev/null 2>&1 && pgrep -x swayosd-server >/dev/null; then
    use_swayosd=true
fi

# Define functions

print_usage() {
    cat <<EOF
Usage: $(basename "$0") -[device] <action> [step]

Devices/Actions:
    -i    Input device
    -o    Output device
    -p    Player application
    -s    Select output device
    -t    Toggle to next output device

Actions:
    i     Increase volume
    d     Decrease volume
    m     Toggle mute

Optional:
    step  Volume change step (default: 5)

Examples:
    $(basename "$0") -o i 5     # Increase output volume by 5
    $(basename "$0") -i m       # Toggle input mute
    $(basename "$0") -p spotify d 10  # Decrease Spotify volume by 10 
    $(basename "$0") -p '' d 10  # Decrease volume by 10 for all players 

EOF
    exit 1
}

notify_vol() {
    angle=$(( (($vol + 2) / 5) * 5 ))
    ico="${icodir}/vol-${angle}.svg"
    bar=$(seq -s "." $(($vol / 15)) | sed 's/[0-9]//g')
    notify_single -h string:x-dunst-stack-tag:volctrl -a "t2" -t 800 -i "${ico}" "${vol}${bar}" "${nsink}"
}

notify_mute() {
    mute=$(pamixer "${srce}" --get-mute | cat)
    [ "${srce}" == "--default-source" ] && dvce="mic" || dvce="speaker"
    if [ "${mute}" == "true" ]; then
        notify_single -h string:x-dunst-stack-tag:volctrl -a "t2" -t 800 -i "${icodir}/muted-${dvce}.svg" "muted" "${nsink}"
    else
        notify_single -h string:x-dunst-stack-tag:volctrl -a "t2" -t 800 -i "${icodir}/unmuted-${dvce}.svg" "unmuted" "${nsink}"
    fi
}

check_player_active() {
    # Return 1 if playerctl is missing or player is inactive
    if ! command -v playerctl >/dev/null 2>&1; then
        return 1
    fi
    # If specific player provided
    if [ -n "$srce" ]; then
        if ! playerctl --player="$srce" status >/dev/null 2>&1; then
            return 1
        fi
    else
        # No specific player, but check if any active player exists
        [ -z "$(playerctl --list-all 2>/dev/null)" ] && return 1
    fi
    return 0
}

change_volume() {
    local action=$1
    local step=$2
    local device=$3
    local mode="--output-volume"

    [ "${srce}" = "--default-source" ] && mode="--input-volume"
    
    case $device in
        "pamixer")
            current_vol=$(pamixer $srce --get-volume)
            if [ "$action" = "i" ]; then
                new_vol=$((current_vol + step))
            else
                new_vol=$((current_vol - step))
            fi
            [ $new_vol -gt 100 ] && new_vol=100
            [ $new_vol -lt 0 ] && new_vol=0
            
            if $use_swayosd; then
                swayosd-client ${mode} $new_vol
                exit 0
            fi
            
            pamixer $srce --set-volume $new_vol
            vol=$new_vol
            ;;
        "playerctl")
            check_player_active || exit 0
            current_vol=$(playerctl --player="$srce" volume 2>/dev/null | awk '{ printf "%.0f", $0 * 100 }')
            [ -z "$current_vol" ] && exit 0
            if [ "$action" = "i" ]; then
                new_vol=$((current_vol + step))
            else
                new_vol=$((current_vol - step))
            fi
            [ $new_vol -gt 100 ] && new_vol=100
            [ $new_vol -lt 0 ] && new_vol=0
            
            player_vol=$(awk "BEGIN { printf \"%.2f\", $new_vol / 100 }")
            playerctl --player="$srce" volume $player_vol
            vol=$new_vol
            ;;
    esac
    
    notify_vol
}

toggle_mute() {
    local device=$1
    local mode="--output-volume"
    [ "${srce}" = "--default-source" ] && mode="--input-volume"
    case $device in
        "pamixer") 
            $use_swayosd && swayosd-client "${mode}" mute-toggle && exit 0
            pamixer $srce -t
            notify_mute
            ;;
        "playerctl")
            check_player_active || exit 0
            local volume_file="/tmp/$(basename "$0")_last_volume_${srce:-all}"
            local current_vol=$(playerctl --player="$srce" volume 2>/dev/null | awk '{ printf "%.2f", $0 }')
            [ -z "$current_vol" ] && exit 0

            if [ "$current_vol" != "0.00" ]; then
                echo "$current_vol" > "$volume_file"
                playerctl --player="$srce" volume 0
            else
                if [ -f "$volume_file" ]; then
                    last_volume=$(cat "$volume_file")
                    playerctl --player="$srce" volume "$last_volume"
                else
                    playerctl --player="$srce" volume 0.5
                fi
            fi
            notify_mute
            ;;
    esac
}

select_output() {
    local selection=$1
    if [ -n "$selection" ]; then
        device=$(pactl list sinks | grep -C2 -F "Description: $selection" | grep Name | cut -d: -f2 | xargs)
        if pactl set-default-sink "$device"; then
            notify-send -h int:transient:1 -h string:x-dunst-stack-tag:volctrl -t 2000 -r 2 -u low "Activated: $selection"
        else
            notify-send -h int:transient:1 -h string:x-dunst-stack-tag:volctrl -t 2000 -r 2 -u critical "Error activating $selection"
        fi
    else
        pactl list sinks | grep -ie "Description:" | awk -F ': ' '{print $2}' | sort
    fi
}

toggle_output() {
    local default_sink=$(pamixer --get-default-sink | awk -F '"' 'END{print $(NF - 1)}')
    mapfile -t sink_array < <(select_output)
    local current_index=$(printf '%s\n' "${sink_array[@]}" | grep -n "$default_sink" | cut -d: -f1)
    local next_index=$(( (current_index % ${#sink_array[@]}) + 1 ))
    local next_sink="${sink_array[next_index-1]}"
    select_output "$next_sink"
}

# Main script logic

# Set default variables
confDir="${XDG_CONFIG_HOME:-$HOME/.config}"
icodir="${confDir}/dunst/icons/vol"
step=5

# Parse options
while getopts "iop:st" opt; do
    case $opt in
        i) device="pamixer"; srce="--default-source"; nsink=$(pamixer --list-sources | awk -F '"' 'END {print $(NF - 1)}') ;;
        o) device="pamixer"; srce=""; nsink=$(pamixer --get-default-sink | awk -F '"' 'END{print $(NF - 1)}') ;;
        p) device="playerctl"; srce="${OPTARG}"; nsink=$(playerctl --list-all 2>/dev/null | grep -w "$srce") ;;
        s) select_output "$(select_output | rofi -dmenu -config "${confDir}/rofi/notification.rasi")"; exit ;;
        t) toggle_output; exit ;;
        *) print_usage ;;
    esac
done

shift $((OPTIND-1))

# Check if device is set
[ -z "$device" ] && print_usage

# Execute action
case $1 in
    i|d) change_volume "$1" "${2:-$step}" "$device" ;;
    m) toggle_mute "$device" ;;
    *) print_usage ;;
esac
