#!/usr/bin/env bash

PIDFILE="/tmp/clipboard-typer.pid"
echo $$ >"$PIDFILE"

DELAY=20
text="$(wl-paste --no-newline)"

cleanup() {
  rm -f "$PIDFILE"
  exit 0
}

trap cleanup SIGINT SIGTERM EXIT

sleep 2

for ((i = 0; i < ${#text}; i++)); do
  ch="${text:i:1}"
  ydotool type --key-delay "$DELAY" "$ch"
done
