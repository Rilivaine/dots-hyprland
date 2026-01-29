hl.on("hyprland.start", function ()

    hl.exec_cmd("vesktop --enable-features=UseOzonePlatform --ozone-platform=wayland --start-minimized")
    hl.exec_cmd("keepassxc")
    hl.exec_cmd("hyprland-per-window-layout")
end)