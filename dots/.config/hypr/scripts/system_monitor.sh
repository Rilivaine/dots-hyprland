#!/usr/bin/env sh

scrDir="$(dirname "$(realpath "$0")")"
. "${scrDir}/common.sh"

pkgChk=("io.missioncenter.MissionCenter" "btop" "htop" "top")

# Extract terminal from Hypr config
term=$(grep '^\$term[[:space:]]*=' "$HOME/.config/hypr/keybindings.conf" | \head -n1 | cut -d '=' -f2- | xargs)
term="${term:-alacritty}"  # Fallback if not found

for pkg in "${pkgChk[@]}"; do
    if pkg_installed "$pkg"; then
        if ! pkill -x "$pkg" 2>/dev/null; then
            if [ "$pkg" = "io.missioncenter.MissionCenter" ]; then
                flatpak run "$pkg" & disown
            else
                "$term" -e "$pkg" & disown
            fi
        fi
        break
    fi
done

