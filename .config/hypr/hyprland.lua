-- ~/.config/hypr/hyprland.lua
-- Docs: https://wiki.hypr.land/Configuring/Start/

---- MY PROGRAMS ----

mainMod    = "SUPER"
terminal   = "kitty"
menu       = "rofi -show drun"
fileManager = "thunar"
browser = "chromium"

---- AUTOSTART ----

hl.on("hyprland.start", function()
    -- hl.exec_cmd("dunst") replaced with quickshell 
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")

    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("~/.config/hypr/scripts/wallpaper-restore.sh")
    hl.exec_cmd("~/.config/hypr/scripts/wallpaper-rotate.sh")
    hl.exec_cmd("sleep 2 && qs")
end)

---- ENVIRONMENT VARIABLES ----

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")

---- INPUT ----

hl.config({
    input = {
        kb_layout = "us,ru",
        follow_mouse = 1,
        sensitivity = 0.5,
        touchpad = {
            natural_scroll = false,
            tap_to_click = true,
        },
    },
})

-- LAYOUT
hl.config({
    dwindle = { preserve_split = true },
})
hl.config({
    master = { new_status = "master" },
})

-- MISC
hl.config({
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },
})

---- SPLIT-OUT FILES ----

require("monitors")
require("keybinds")
require("look")
require("rules")

-- HyprMod managed settings
require("hyprland-gui")


-- Screenshot keybindings (added automatically)
hl.bind("PRINT", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh area"))
hl.bind("SUPER + PRINT", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh full"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh window"))
hl.bind("CTRL + PRINT", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh copy"))

-- Laptop screen brightness keys
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
