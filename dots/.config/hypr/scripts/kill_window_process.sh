kill $(pstree -p $(hyprctl activewindow -j | jq -r .pid) | head -n1 | grep -oP '\(\K[0-9]+')
