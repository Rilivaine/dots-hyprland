#!/usr/bin/env sh

if ! pgrep -x spotify >/dev/null; then
  spotify &
  disown
  # Wait a bit for MPRIS interface to register
  for _ in $(seq 1 10); do
    playerctl --player=spotify status >/dev/null 2>&1 && break
    sleep 0.3
  done
fi

playerctl play-pause --player=spotify
