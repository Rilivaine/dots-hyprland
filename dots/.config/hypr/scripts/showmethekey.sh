#!/bin/bash

# Ensure environment vars are set for GUI
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-wayland-1}
export DISPLAY=${DISPLAY:-:0}

# Toggle logic
if pgrep -f showmethekey-gtk >/dev/null; then
    pkill -f showmethekey-gtk
else
    showmethekey-gtk -k -A &
fi

