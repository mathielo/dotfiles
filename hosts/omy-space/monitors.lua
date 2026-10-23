-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 1
local omarchy_monitor_scale = 1

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Dell U2414H, portrait (rotated 90° clockwise) on the left. Rotated it is 1080x1920.
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "0x0", scale = 1, transform = 1 })

-- ROG PG348Q ultrawide on the right, centered vertically on the Dell ((1920 - 1440) / 2 = 240).
-- vrr = 2 enables G-Sync for fullscreen apps only; use 1 to keep it on all the time.
hl.monitor({ output = "DP-3", mode = "3440x1440@100", position = "1080x240", scale = 1, vrr = 2 })

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })
