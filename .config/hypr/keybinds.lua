-- ~/.config/hypr/keybinds.lua
-- Migrated from keybinds.conf
-- Docs: https://wiki.hypr.land/Configuring/Basics/Binds/
--       https://wiki.hypr.land/Configuring/Basics/Dispatchers/

local home = os.getenv("HOME")
local menu = "rofi -show drun"

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal)) 
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("pgrep -x rofi >/dev/null && pkill -x rofi || " .. menu)) -- Toggle launcher
-- Отключено по запросу: круговое меню
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + C", hl.dsp.window.close())

hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd("hyprlock")) -- Lock screen

hl.bind(mainMod .. " + GRAVE", hl.dsp.exec_cmd("qs ipc call powermenu toggle")) -- Power menu

hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("qs ipc call settings toggle")) -- Settings

hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("qs -n -p ~/.config/quickshell/hyprquickpaper")) -- Wallpapers

hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = 0 })) -- Fullscreen

hl.bind(mainMod .. " + O", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/opacity.sh")) -- Opacity

hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("python3 " .. home .. "/.config/43pr/bin/theme.py toggle")) -- Light/dark toggle

hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("qs ipc call notifications toggle")) -- Notifications

-- Отключено по запросу: список задач

-- Mouse move/resize window
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })


-- Clipboard
-- Отключено по запросу: история буфера обмена

-- Screenshot fullscreen
hl.bind("Delete", hl.dsp.exec_cmd("sh -c 'file=" .. home .. "/Pictures/$(date +%s).png; grim \"$file\"; wl-copy < \"$file\"; qs ipc call screenshot notify \"$file\"'"))
-- Screenshot area select
hl.bind("SHIFT + Delete", hl.dsp.exec_cmd("sh -c 'file=" .. home .. "/Pictures/$(date +%s).png; grim -g \"$(slurp)\" \"$file\"; wl-copy < \"$file\"; qs ipc call screenshot notify \"$file\"'"))

-- Keyboard layout
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("hyprctl switchxkblayout current next"))

-- Toggle float window, center and resize
hl.bind(mainMod .. " + Space", function()
    local w = hl.get_active_window()

    if w ~= nil and w.floating then
        hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
        return
    end

    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))

    w = hl.get_active_window()
    local mon = hl.get_active_monitor()

    if w ~= nil and mon ~= nil then
        local target_w = math.floor(mon.width * 0.4)
        local target_h = math.floor(mon.height * 0.4)

        hl.dispatch(hl.dsp.window.resize({
            x = target_w,
            y = target_h,
            relative = false
        }))

        local target_x = (mon.x or 0) + math.floor((mon.width - target_w) / 2)
        local target_y = (mon.y or 0) + math.floor((mon.height - target_h) / 2)

        hl.dispatch(hl.dsp.window.move({
            x = target_x,
            y = target_y,
            relative = false
        }))
    end
end)

-- Zoom
local function zoomfunction(value)
    local zoomvalue = hl.get_config("cursor:zoom_factor")
    if (zoomvalue + value) > 1.5 then
        hl.config({ cursor = { zoom_factor = 1.5 } })
    elseif (zoomvalue + value) < 1.0 then
        hl.config({ cursor = { zoom_factor = 1.0 } })
    else
        hl.config({ cursor = { zoom_factor = zoomvalue + value } })
    end
end
hl.bind(mainMod .. " + mouse_down", function() zoomfunction(-0.5) end, { repeating = true })
hl.bind(mainMod .. " + mouse_up", function() zoomfunction(0.5) end, { repeating = true })

--# Zoom with keypad
hl.bind(mainMod .. " + code:82", function() zoomfunction(-0.3) end, { repeating = true })
hl.bind(mainMod .. " + code:86", function() zoomfunction(0.3) end, { repeating = true })

-- VERIFY: exit dispatcher. Docs explicitly say to double check the exit
-- dispatcher call when moving to Lua.
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())

-- Workspaces 1-10, and move-to-workspace with SHIFT (confirmed pattern from
-- the official example config)
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Media keys (confirmed pattern from the official example config)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
