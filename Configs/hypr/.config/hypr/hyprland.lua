-- Hyprland config for DankMaterialShell
-- Manages: monitors, env, input, keybinds, animations, window rules
-- DMS owns: wallpaper, lock, idle, status bar/popups, theme
-- Sources *.lua files from dms/ that DMS regenerates automatically.

-- 1. Run the config once to set up the Lua environment.
-- (hyprland 0.55+ treats hyprland.lua as the active entry point; the
-- file at ~/.config/hypr/hyprland.lua is a symlink to this one.)

-----------------
---- MONITORS ----
-----------------

-- DMS writes monitor definitions to ./dms/outputs.lua. Source it so
-- any output changes you make in the DMS control center take effect.
-- (Falls back to "preferred" if outputs.lua is empty.)
do
    local ok, err = pcall(dofile, "dms/outputs.lua")
    if not ok then
        hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
    end
end

-- 2. Quick local bindings to dms-generated snippets.
require("dms.colors")        -- matugen-driven border colors
require("dms.layout")        -- gaps / rounding / bar xray
require("dms.cursor")        -- cursor theme (currently empty placeholder)
require("dms.windowrules")   -- DMS-managed window rules

-------------------
---- AUTOSTART ----
-------------------

-- Minimum startup: wire up the user session, apply the GTK theme, and
-- start PAM kwallet. Terminal/browser launch on demand.
hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("systemctl --user start hyprland-session.target")
    hl.exec_cmd("/usr/lib/pam_kwallet_init")
end)

-- Run on every reload.
hl.exec_cmd("kbuildsycoca6 --noincremental")
hl.exec_cmd('gsettings set org.gnome.desktop.interface gtk-theme "Breeze-Dark"')
hl.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"')

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_THEME",           "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE",            "24")
hl.env("HYPRCURSOR_THEME",        "Bibata-Modern-Ice")
hl.env("HYPRCURSOR_SIZE",         "24")
hl.env("XDG_CURRENT_DESKTOP",     "Hyprland")
hl.env("XDG_SESSION_TYPE",        "wayland")
hl.env("XDG_SESSION_DESKTOP",     "Hyprland")
hl.env("QT_QPA_PLATFORMTHEME",    "gtk3")
hl.env("QT_QPA_PLATFORMTHEME_QT6","gtk3")
hl.env("XDG_MENU_PREFIX",         "arch-")
hl.env("QT_QPA_PLATFORM",         "wayland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 4,
        gaps_out = 4,
        border_size = 2,

        -- Overridden by require("dms.colors"); kept as fallback only.
        col = {
            active_border   = "rgb(5ddbbc)",
            inactive_border = "rgb(7e949f)",
        },

        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    cursor = {
        default_monitor   = "",
        enable_hyprcursor = true,
    },

    decoration = {
        rounding       = 12,
        rounding_power = 2,
        active_opacity   = 1.0,
        inactive_opacity = 0.9,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        blur = {
            enabled  = true,
            size     = 8,
            passes   = 2,
            vibrancy = 0.1696,
        },
    },

    dwindle = { preserve_split = true },
    master  = { new_status     = "master" },

    misc  = { middle_click_paste = false },
    debug = { disable_logs        = false },

    input = {
        kb_layout  = "us",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = { natural_scroll = false },
    },
})

-------------------
---- ANIMATIONS ----
-------------------

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1}, {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0}, {1, 1} } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5}, {0.75, 1.0} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0}, {0.1, 1} } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = false })
hl.animation({ leaf = "workspacesIn",  enabled = false })
hl.animation({ leaf = "workspacesOut", enabled = false })

-----------------------
---- KEYBINDINGS  -----
-----------------------

local mainMod = "SUPER"

-- DMS is the entry point for most things.
hl.bind(mainMod .. " + SPACE",       hl.dsp.exec_cmd("dms ipc call launcher open"))
hl.bind(mainMod .. " + M",           hl.dsp.exec_cmd("dms ipc call processlist focusOrToggle"))
hl.bind(mainMod .. " + COMMA",       hl.dsp.exec_cmd("dms ipc call settings focusOrToggle"))
hl.bind(mainMod .. " + N",           hl.dsp.exec_cmd("dms ipc call notifications toggle"))
hl.bind(mainMod .. " + SHIFT + N",   hl.dsp.exec_cmd("dms ipc call notepad toggle"))
hl.bind(mainMod .. " + V",           hl.dsp.exec_cmd("dms ipc call clipboard toggle"))
hl.bind(mainMod .. " + X",           hl.dsp.exec_cmd("dms ipc call powermenu toggle"))
hl.bind(mainMod .. " + TAB",         hl.dsp.exec_cmd("dms ipc call hypr toggleOverview"))
hl.bind(mainMod .. " + SHIFT + SLASH", hl.dsp.exec_cmd("dms ipc call keybinds toggle hyprland"))

-- Lock: send to DMS (it owns the session-lock surface).
hl.bind(mainMod .. " + ALT + L",     hl.dsp.exec_cmd("dms ipc call lock lock"))
hl.bind(mainMod .. " + SHIFT + E",   hl.dsp.exit())
hl.bind("CTRL + ALT + DELETE",       hl.dsp.exec_cmd("dms ipc call processlist focusOrToggle"))

-- Apps.
local terminal = "kitty"
local browser  = "/var/lib/flatpak/exports/bin/app.zen_browser.zen"

hl.bind(mainMod .. " + T",           hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E",           hl.dsp.exec_cmd("kitty yazi"))
hl.bind(mainMod .. " + F",           hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + P",           hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J",           hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + Q",           hl.dsp.window.close())
hl.bind(mainMod .. " + W",           hl.dsp.window.float({ action = "toggle" }))

-- Focus + bring-to-top.
hl.bind(mainMod .. " + TAB", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
end)
hl.bind("ALT + TAB", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
end)

local function focus(direction)
    hl.bind(mainMod .. " + " .. direction, function()
        hl.dispatch(hl.dsp.focus({ direction = direction:sub(1, 1):lower() }))
        hl.dispatch(hl.dsp.window.bring_to_top())
    end)
end
focus("left"); focus("right"); focus("up"); focus("down")

-- Workspaces.
for i = 1, 9 do
    hl.bind(mainMod .. " + "            .. i, hl.dsp.focus({ workspace = tostring(i) }))
    hl.bind(mainMod .. " + SHIFT + "    .. i, hl.dsp.window.move({ workspace = tostring(i) }))
end
hl.bind(mainMod .. " + 0",            hl.dsp.focus({ workspace = "10" }))
hl.bind(mainMod .. " + SHIFT + 0",    hl.dsp.window.move({ workspace = "10" }))

-- Mouse.
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Multimedia keys (DMS audio + brightness services).
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("dms ipc call audio increment 5"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("dms ipc call audio decrement 5"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("dms ipc call audio mute"),        { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("dms ipc call audio micmute"),     { locked = true, repeating = true })
hl.bind("XF86AudioNext",        hl.dsp.exec_cmd("dms ipc call mpris next"),        { locked = true })
hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd("dms ipc call mpris previous"),    { locked = true })
hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd("dms ipc call mpris playPause"),   { locked = true })
hl.bind("XF86AudioPause",       hl.dsp.exec_cmd("dms ipc call mpris playPause"),   { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("dms ipc call brightness increment 5 ''"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("dms ipc call brightness decrement 5 ''"), { locked = true, repeating = true })

-- Color picker + screenshots.
hl.bind(mainMod .. " + SHIFT + I", hl.dsp.exec_cmd("dms ipc call color-picker open"))
hl.bind(mainMod .. " + S",         hl.dsp.exec_cmd("dms screenshot"))
hl.bind(mainMod .. " + CTRL + S",  hl.dsp.exec_cmd("dms screenshot full"))
hl.bind(mainMod .. " + ALT + S",   hl.dsp.exec_cmd("dms screenshot window"))

------------------------------
---- WINDOWS AND WORKSPACES --
------------------------------

-- Suppress maximize flicker.
hl.window_rule({
    match          = { class = ".*" },
    suppress_event = "maximize",
})

-- Stale XWayland windows: don't auto-focus empty-class popups.
hl.window_rule({
    match    = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})

-- Picture-in-Picture.
hl.window_rule({
    match              = { title = "(Picture-in-Picture)" },
    float              = true,
    size               = { "monitor_w * 0.2", "monitor_h * 0.2" },
    move               = { "monitor_w * 0.775", "monitor_h * 0.775" },
    no_initial_focus   = true,
    opacity            = "1.0 override",
    keep_aspect_ratio  = true,
})

-- Application Not Responding dialog: center it.
hl.window_rule({
    match = { title = "(Application Not Responding)" },
    move  = { "38%", "60%" },
})

-- Idle inhibit for fullscreen windows (DMS idle honors this).
hl.window_rule({
    match        = { class = ".*" },
    idle_inhibit = "fullscreen",
})

-- Layer rules.
hl.layer_rule({ match = { namespace = "^(dms)$" },  blur = true })
hl.layer_rule({ match = { namespace = "rofi" },     blur = true })
