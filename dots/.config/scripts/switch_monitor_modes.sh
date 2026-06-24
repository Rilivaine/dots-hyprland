#!/bin/bash

# CONFIGURE YOUR MONITOR NAMES
INTERNAL="eDP-1"     # Built-in display
EXTERNAL="HDMI-A-1"  # External monitor

MODE="$1"

# Fallback if no mode passed
if [ -z "$MODE" ]; then
    echo "Usage: $0 [mirror|extend|external|internal]"
    exit 1
fi

case "$MODE" in
    mirror)
        # Use the lowest common resolution for mirroring
        wlr-randr --output "$INTERNAL" --mode 1920x1080 --pos 0x0
        wlr-randr --output "$EXTERNAL" --mode 1920x1080 --pos 0x0
        ;;
    
    extend)
        wlr-randr --output "$INTERNAL" --mode 1920x1080 --pos 0x0
        wlr-randr --output "$EXTERNAL" --mode 1920x1080 --pos 1920x0
        ;;

    external)
        wlr-randr --output "$INTERNAL" --off
        wlr-randr --output "$EXTERNAL" --mode 1920x1080 --pos 0x0
        ;;

    internal)
        wlr-randr --output "$EXTERNAL" --off
        wlr-randr --output "$INTERNAL" --mode 1920x1080 --pos 0x0
        ;;

    *)
        echo "Invalid mode. Use one of: mirror, extend, external, internal"
        exit 1
        ;;
esac

# Optional: Restart waybar, hyprpaper, etc if needed
# pkill -SIGUSR2 waybar

