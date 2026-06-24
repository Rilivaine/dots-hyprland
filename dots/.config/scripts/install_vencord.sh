#!/bin/sh
set -euo pipefail

if [ "$(id -u)" -eq 0 ]; then
  echo "Run me as normal user, not root!"
  exit 1
fi

if grep -q "CHROMEOS_RELEASE_NAME" /etc/lsb-release 2>/dev/null; then
  echo "ChromeOS is not supported! Use the chrome extension. https://chromewebstore.google.com/detail/vencord-web/cbghhgpcnddeihccjmnadmkaejncjndb"
  exit 1
fi

if ! command -v sudo >/dev/null 2>&1; then
  echo "sudo is required but not found. Please install sudo."
  exit 1
fi

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

outfile=$(mktemp --tmpdir="$HOME" vencord-installer.XXXXXX)
trap 'rm -f "$outfile"' EXIT

echo "Downloading Vencord installer..."
curl -fSsL "https://github.com/Vendicated/VencordInstaller/releases/latest/download/VencordInstallerCli-Linux" -o "$outfile"

chmod +x "$outfile"

echo "Running installer with sudo..."
sudo env \
  XDG_CONFIG_HOME="$XDG_CONFIG_HOME" \
  XDG_DATA_HOME="$XDG_DATA_HOME" \
  SUDO_USER="$(whoami)" \
  "$outfile" -install -branch auto

echo "Done."
