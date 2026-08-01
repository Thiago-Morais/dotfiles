---------------------
---- KEYBINDINGS ----
---------------------

-- local mainMod = "ALT" -- Sets "Windows" key as main modifier
require("config.defaults")
local b = require("config.binds-utils")

local RIGHT = "right"
local LEFT = "left"
local UP = "up"
local DOWN = "down"

local DIRECTIONS = {
	{ dir = "right", preffix = "to the ", keys = { "right", "L" }, suffix = "" },
	{ dir = "left", preffix = "to the ", keys = { "left", "H" }, suffix = "" },
	{ dir = "up", preffix = "", keys = { "up", "K" }, suffix = "wards" },
	{ dir = "down", preffix = "", keys = { "down", "J" }, suffix = "wards" },
}

local _desc = ""

-- https://wiki.hyprland.org/Configuring/Binds/
hl.bind(
	b.combo(MainMod, "ALT", "SHIFT", "P"),
	hl.dsp.exec_cmd("loginctl terminate-user ''"),
	{ description = "Exits Hyprland by terminating the user sessions" }
)
-- ====== Other Window Ations ======
hl.bind(b.combo(MainMod, "Q"), hl.dsp.window.close(), { description = "Closes (not kill) current window" })
hl.bind(b.combo(MainMod, "V"), hl.dsp.window.float(), { description = "Switches current window between floating and tiling mode" })
hl.bind(b.combo(MainMod, "F"), hl.dsp.window.fullscreen({ mode = "maximized" }), { description = "Toggles current window fullscreen mode" })
_desc = "Toggles current window maximize mode"
hl.bind(b.combo(MainMod, "SHIFT", "F"), hl.dsp.window.fullscreen({ mode = "fullscreen" }), { description = _desc })
_desc = "Resize window to the size of the screen"
hl.bind(b.combo(MainMod, "ALT", "F"), function()
	local monitor = hl.get_active_monitor() or { width = 1920, height = 1080 }
	hl.dispatch(hl.dsp.window.resize({ x = monitor.width, y = monitor.height }))
	hl.dispatch(hl.dsp.window.center())
end, { description = _desc })
hl.bind(b.combo(MainMod, "mouse:272"), hl.dsp.window.drag(), { drag = true, desc = "Move the window towards a direction" })

local function dir_as_string(direction)
	return direction.preffix .. direction.dir .. direction.suffix
end

-- Move window / focus / workspace towards a direction
for _, d in ipairs(DIRECTIONS) do
	for _, key in ipairs(d.keys) do
		-- Move window towards a direction
		local dir = d.dir:sub(1, 1)
		hl.bind(b.combo(MainMod, "SHIFT", key), hl.dsp.window.move({ direction = dir }), { desc = "Move active window " .. dir_as_string(d) })

		-- Move window towards a direction and through groups
		hl.bind(b.combo(MainMod, "ALT", key), function()
			hl.dispatch(hl.dsp.window.move({ direction = dir, group_aware = true }))
		end, { desc = "Move active window " .. dir_as_string(d) })

		-- Move keyboard focus in a direction
		hl.bind(b.combo(MainMod, key), hl.dsp.focus({ direction = dir }), { desc = "Move focus " .. dir_as_string(d) })
	end
end

hl.bind(b.combo(MainMod, "SHIFT", "slash"), hl.dsp.window.center(), { desc = "Center active window downwards" })

-- ## Resizing windows ##
-- Activate keyboard window resize mode (left commented out, as in the original)
-- hl.bind(b.combo(mainMod, "R"), hl.dsp.submap("resize"), { desc = "Activates window resizing mode" })

local resizeSteps = {
	{ keys = { "right", "l" }, x = 30, y = 0 },
	{ keys = { "left", "h" }, x = -30, y = 0 },
	{ keys = { "up", "k" }, x = 0, y = -30 },
	{ keys = { "down", "j" }, x = 0, y = 30 },
}

hl.define_submap("resize", function()
	for _, step in ipairs(resizeSteps) do
		for _, key in ipairs(step.keys) do
			hl.bind(key, hl.dsp.window.resize({ x = step.x, y = step.y, relative = true }), { repeating = true })
		end
	end
	hl.bind("escape", hl.dsp.submap("reset"))
end)

-- Quick resize window with keyboard
for _, step in ipairs(resizeSteps) do
	for _, key in ipairs(step.keys) do
		hl.bind(b.combo(MainMod, "CTRL", "SHIFT", key), hl.dsp.window.resize({ x = step.x, y = step.y, relative = true }), { repeating = true })
	end
end

-- Resize / move window with mainMod + LMB/RMB and dragging
hl.bind(b.combo(MainMod, "mouse:273"), hl.dsp.window.resize(), { drag = true, desc = "Resize the window towards a direction" })
hl.bind(b.combo(MainMod, "mouse:272"), hl.dsp.window.drag(), { drag = true, desc = "Drag window" })
-- ## Resizing Windows End ##

-- ====== Layout ======
_desc = "Increase current window to the largest size; Swaps position and size with the current biggest window"
hl.bind(b.combo(MainMod, "CTRL", "F"), hl.dsp.layout("movetoroot"), { description = _desc })
hl.bind(b.combo(MainMod, "CTRL", "U"), hl.dsp.layout("movetoroot"), { description = _desc })
hl.bind(b.combo(MainMod, "P"), hl.dsp.window.pin(), { description = "Pin current window (shows on all workspaces)" })
hl.bind(b.combo(MainMod, "U"), hl.dsp.layout("togglesplit"), { description = "Toggles current window split mode" })
hl.bind(b.combo(MainMod, "SHIFT", "U"), hl.dsp.layout("swapsplit"), { description = "Swap current window position within work tree" })

local function cycle_windows()
	hl.dispatch(hl.dsp.window.cycle_next())
	hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end
hl.bind(b.combo(MainMod, "ALT", "Tab"), cycle_windows, { repeating = true, description = "Cycle between windows" })
hl.bind(b.combo(MainMod, "Tab"), cycle_windows, { repeating = true, description = "Cycle between windows" })

-- ======= Workspace Actions =======

local window_move = hl.dsp.window.move
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	local ws = i
	-- Switch workspaces with mainMod + [0-9]
	hl.bind(b.combo(MainMod, key), hl.dsp.focus({ workspace = ws }), { desc = "Focus workspace " .. ws })
	-- Move active window to a workspace with mainMod + CTRL + [0-9]
	hl.bind(b.combo(MainMod, "CTRL", key), window_move({ workspace = ws }), { desc = "Move window and switch to workspace " .. ws })
	-- Same as above, but doesn't switch to the workspace
	hl.bind(b.combo(MainMod, "SHIFT", key), window_move({ workspace = ws, follow = false }), { desc = "Move window silently to workspace " .. ws })
	-- Move active workspace to the current monitor and switch to it
	hl.bind(b.combo(MainMod, "ALT", key), function()
		hl.dispatch(hl.dsp.workspace.move({ workspace = ws, monitor = "current" }))
		hl.dispatch(hl.dsp.focus({ workspace = ws }))
	end, { desc = "Move workspace " .. ws .. " to current monitor and switch to it" })
end

-- Special workspaces (scratchpads)
do
	local ws = "special:音楽"
	hl.bind(b.combo(MainMod, "CTRL", "M"), window_move({ workspace = ws }), { desc = "Move window and switch to music workspace" })
	hl.bind(b.combo(MainMod, "SHIFT", "M"), window_move({ workspace = ws, follow = false }), { desc = "Move window silently to music workspace" })
	hl.bind(b.combo(MainMod, "M"), hl.dsp.workspace.toggle_special("音楽"), { desc = "Toggles the Music workspace" })
	ws = "special:特別"
	hl.bind(b.combo(MainMod, "CTRL", "equal"), window_move({ workspace = ws }), { desc = "Move active window to Special workspace" })
	hl.bind(b.combo(MainMod, "SHIFT", "equal"), window_move({ workspace = ws, follow = false }), { desc = "Move active window silently to Special workspace" })
	hl.bind(b.combo(MainMod, "equal"), hl.dsp.workspace.toggle_special("特別"), { desc = "Toggles the Special workspace" })

	ws = "-1"
	hl.bind(b.combo(MainMod, "CTRL", "left"), window_move({ workspace = ws }), { desc = "Move window and switch to the next workspace" })
	hl.bind(b.combo(MainMod, "SHIFT", "left"), window_move({ workspace = ws, follow = false }), { desc = "Move window silently to the next workspace" })
	ws = "+1"
	hl.bind(b.combo(MainMod, "CTRL", "right"), window_move({ workspace = ws }), { desc = "Move window and switch to the previous workspace" })
	hl.bind(b.combo(MainMod, "SHIFT", "right"), window_move({ workspace = ws, follow = false }), { desc = "Move window silently to the previous workspace" })
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(b.combo(MainMod, "mouse_down"), hl.dsp.focus({ workspace = "e+1" }), { desc = "Scroll through workspaces incrementally" })
hl.bind(b.combo(MainMod, "mouse_up"), hl.dsp.focus({ workspace = "e-1" }), { desc = "Scroll through workspaces decrementally" })
hl.bind(b.combo(MainMod, "slash"), hl.dsp.focus({ workspace = "previous" }), { desc = "Switch to the previous workspace" })

-- ======= Launch Programs =======
hl.bind(b.combo(MainMod, "SPACE"), hl.dsp.exec_cmd(App_launcher .. " &"), { description = "Runs your application launcher" })
hl.bind(b.combo(MainMod, "CTRL", "SPACE"), hl.dsp.exec_cmd(Window_switcher .. " &"), { description = "Runs your window switcher" })
hl.bind(b.combo(MainMod, "RETURN"), hl.dsp.exec_cmd(Terminal .. " &"), { description = "Opens your preferred terminal emulator (" .. Terminal .. ")" })
hl.bind(b.combo(MainMod, "E"), hl.dsp.exec_cmd(File_manager .. " &"), { description = "Opens your preferred filemanager (" .. File_manager .. ")" })
hl.bind(b.combo(MainMod, "B"), hl.dsp.exec_cmd(Browser .. " &"), { description = "Open your preferred browser (" .. Browser .. ")" })
_desc = "Open your preferred task manager (" .. Task_manager .. ")"
hl.bind(b.combo(MainMod, "Escape"), hl.dsp.exec_cmd(("%s --class %s -e %s &"):format(Terminal, Task_manager, Task_manager)), { description = _desc })
hl.bind(b.combo(MainMod, "O"), function()
	hl.dsp.exec_cmd(("%s --class %s %s cd %s; $EDITOR %s & disown"):format(Terminal, Note_taker, Terminal_middlefix, Note_vault, Terminal_suffix))
	hl.dsp.exec_cmd(Note_taker .. " &")
end, { description = "Open your preferred note taking app (" .. Note_taker .. ")" })
_desc = "Open your preferred code editor (" .. os.getenv("EDITOR") .. ")"
hl.bind(b.combo(MainMod, "N"), hl.dsp.exec_cmd(("%s $EDITOR %s & disown"):format(Terminal_preffix, Terminal_suffix)), { description = _desc })
hl.bind(b.combo(MainMod, "I"), hl.dsp.exec_cmd(Color_picker .. " -ar"), { description = "Open your preferred color picker (" .. Color_picker .. ")" })
hl.bind(b.combo(MainMod, "PERIOD"), hl.dsp.exec_cmd(Emoji_picker .. " &"), { description = "Open emoji picker (" .. Emoji_picker .. ")" })
hl.bind(b.combo(MainMod, "CTRL", "V"), hl.dsp.exec_cmd(Terminal .. " --class clipse -e 'clipse' &"), { description = "Open clipboard history" })
hl.bind(b.combo(MainMod, "Y"), hl.dsp.exec_cmd(Music_player .. " &"), { description = "Open your preferred music player (" .. Music_player .. ")" })

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

-- ======= Volume Control =======
local display_volume_cmd = "wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -oP '\\d+\\.\\d+' | awk '{print $1 * 100}' | head -1 > " .. Wob_path

-- Laptop multimedia keys for volume
local raise_volume_cmd = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(raise_volume_cmd .. " && " .. display_volume_cmd), { repeating = true, locked = true })
local lower_volume_cmd = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-"
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(lower_volume_cmd .. " && " .. display_volume_cmd), { repeating = true, locked = true })
do
	local mute_volume_cmd = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
	local display_mute_cmd = "wpctl get-volume @DEFAULT_AUDIO_SINK@"
		.. " | grep -oP '\\d+\\.\\d+.*'"
		.. " | awk '/\\[MUTED\\]/{print 0; exit} {print $1 * 100}'"
		.. " | head -1 > "
		.. Wob_path
	hl.bind("XF86AudioMute", hl.dsp.exec_cmd(mute_volume_cmd .. " && " .. display_mute_cmd), { repeating = true, locked = true })
end
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { repeating = true, locked = true })

-- ======= Playback Control =======
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { description = "Toggles play/pause", locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { description = "Toggles play/pause", locked = true })
hl.bind(MainMod .. " + XF86AudioMute", hl.dsp.exec_cmd("playerctl play-pause"), { description = "Toggles play/pause", locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { description = "Next track", locked = true })
hl.bind(MainMod .. " + XF86AudioRaiseVolume", hl.dsp.exec_cmd("playerctl next"), { description = "Next track", locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { description = "Previous track", locked = true })
hl.bind(MainMod .. " + XF86AudioLowerVolume", hl.dsp.exec_cmd("playerctl previous"), { description = "Previous track", locked = true })

-- ======= Screen Brightness =======
local all_backlight_devices = "brightnessctl -l -c backlight|grep -oP \"Device '\\K[^']+\""
-- #Increases brightness +4%
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(all_backlight_devices .. " | xargs -I {} brightnessctl -e -d {} s +4%"))
-- #Decreases brightness -4%
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(all_backlight_devices .. " | xargs -I {} brightnessctl -e -d {} s 4%-"))

hl.bind(MainMod .. " + ALT + P", hl.dsp.exec_cmd("hyprlock"), { description = "Lock the screen" })
hl.bind(MainMod .. " + ALT + W", hl.dsp.exec_cmd("killall -SIGUSR2 waybar"), { description = "Reload/restarts Waybar" })

-- ======= Monitors ======
hl.bind(b.combo(MainMod, "CTRL", "Tab"), hl.dsp.focus({ monitor = "+1" }), { desc = "Move focus to next monitor" })
hl.bind(b.combo(MainMod, "ALT", "Tab"), hl.dsp.focus({ monitor = "+1" }), { desc = "Move focus to next monitor" })

-- Move window / focus / workspace towards a direction
for _, d in ipairs(DIRECTIONS) do
	for _, key in ipairs(d.keys) do
		local dir = d.dir:sub(1, 1)
		-- Move active workspace to the monitor in that direction
		hl.bind(b.combo(MainMod, "CTRL", key), hl.dsp.workspace.move({ monitor = dir }), { desc = "Move active workspace to monitor " .. dir_as_string(d) })
	end
end

-- ======= Others =======
hl.bind(b.combo(MainMod, "SHIFT", "P"), hl.dsp.exec_cmd("hyprpicker -a"), { desc = "Open color picker" })

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
