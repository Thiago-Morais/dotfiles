---------------------
---- KEYBINDINGS ----
---------------------

-- local mainMod = "ALT" -- Sets "Windows" key as main modifier
require("config.defaults")
local b = require("config.binds-utils")
local _desc = ""
require("config.binds.layout").setup()
require("config.binds.workspaces").setup()
require("config.binds.monitors").setup()
require("config.binds.launch_programs").setup()
require("config.binds.volume_controls").setup()
require("config.binds.playback_control").setup()

-- https://wiki.hyprland.org/Configuring/Binds/
_desc = "Exits Hyprland by terminating the user sessions"
hl.bind(b.combo(MainMod, "ALT", "SHIFT", "P"), hl.dsp.exec_cmd("loginctl terminate-user ''"), { description = _desc })

-- ====== Other Window Ations ======
hl.bind(b.combo(MainMod, "F"), hl.dsp.window.fullscreen({ mode = "maximized" }), { description = "Toggles current window fullscreen mode" })
_desc = "Toggles current window maximize mode"
hl.bind(b.combo(MainMod, "SHIFT", "F"), hl.dsp.window.fullscreen({ mode = "fullscreen" }), { description = _desc })
_desc = "Resize window to the size of the screen (floating)"
hl.bind(b.combo(MainMod, "ALT", "F"), function()
	local monitor = hl.get_active_monitor() or { width = 1920, height = 1080 }
	hl.dispatch(hl.dsp.window.resize({ x = monitor.width, y = monitor.height }))
	hl.dispatch(hl.dsp.window.center())
end, { description = _desc })
hl.bind(b.combo(MainMod, "SHIFT", "slash"), hl.dsp.window.center(), { desc = "Center active window downwards (floating)" })

-- ======= Commands Shortcuts =======
_desc = "Syncronize all remote directories with preferred synchronization program"
hl.bind(b.combo(MainMod, "ALT", "S"), hl.dsp.exec_cmd(Terminal .. " -e " .. Sync_all_remotes), { description = _desc })

-- ======= System toggles =======
_desc = "Toggles bluetooth on/off"
hl.bind(b.combo(MainMod, "ALT", "B"), hl.dsp.exec_cmd("/home/thiago/.config/hypr/scripts/bluetooth-toggle.sh"), { description = _desc, release = true })

-- ======= Screenshot/Printscreen =======
hl.bind(b.combo("Print"), hl.dsp.exec_cmd(Shot_region), { description = "Creates a screenshot of an area" })
hl.bind(b.combo(MainMod, "SHIFT", "S"), hl.dsp.exec_cmd(Shot_region), { description = "Creates a screenshot of an area" })
hl.bind(b.combo("CTRL", "Print"), hl.dsp.exec_cmd(Shot_window), { description = "Creates a screenshot of the active window" })
hl.bind(b.combo("ALT", "Print"), hl.dsp.exec_cmd(Shot_screen), { description = "Creates a screenshot of the active display" })

-- ======= Screen Recording =======
hl.bind(b.combo(MainMod, "SHIFT", "R"), hl.dsp.exec_cmd(Shot_screen), { description = "Records screen" })

-- ======= Grouping Windows =======
hl.bind(b.combo(MainMod, "G"), hl.dsp.group.toggle(), { description = "Toggles  current window group mode (ungroup all related)" })
hl.bind(b.combo(MainMod, "Tab"), hl.dsp.group.next(), { description = "Switches to the next window in the group", repeating = true })
hl.bind(b.combo(MainMod, "SHIFT", "Tab"), hl.dsp.group.prev(), { description = "Switches to the next window in the group", repeating = true })

-- -- ======= Toggle Gaps =======
-- hl.bind(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd('hyprctl --batch "keyword general:gaps_out 5;keyword general:gaps_in 3"'), {
-- 	description = "Set CachyOS default gaps",
-- })
-- hl.bind(mainMod .. " +  + G", hl.dsp.exec_cmd('hyprctl --batch "keyword general:gaps_out 0;keyword general:gaps_in 0"'), {
-- 	description = "Remove gaps between window",
-- })

-- ======= Screen Brightness =======
local all_backlight_devices = "brightnessctl -l -c backlight|grep -oP \"Device '\\K[^']+\""
-- #Increases brightness +4%
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(all_backlight_devices .. " | xargs -I {} brightnessctl -e -d {} s +4%"))
-- #Decreases brightness -4%
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(all_backlight_devices .. " | xargs -I {} brightnessctl -e -d {} s 4%-"))

-- ======= Others =======
hl.bind(b.combo(MainMod, "SHIFT", "P"), hl.dsp.exec_cmd("hyprpicker -a"), { desc = "Open color picker" })
hl.bind(b.combo(MainMod, "ALT", "P"), hl.dsp.exec_cmd("hyprlock"), { description = "Lock the screen" })
hl.bind(b.combo(MainMod, "ALT", "W"), hl.dsp.exec_cmd("killall -SIGUSR2 waybar"), { description = "Reload/restarts Waybar" })

-- ======= BINDINGS CONFIGS =======
-- https://wiki.hypr.land/Configuring/Basics/Binds/
hl.config({
	binds = {
		hide_special_on_workspace_change = true,
		workspace_back_and_forth = false,
		allow_workspace_cycles = true,
		workspace_center_on = true,
		focus_preferred_method = 1,
		movefocus_cycles_fullscreen = true,
		window_direction_monitor_fallback = true,
		disable_keybind_grabbing = true,
		allow_pin_fullscreen = true,
		drag_threshold = 1,
	},
})
