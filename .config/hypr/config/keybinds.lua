---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier
-- local mainMod = "ALT" -- Sets "Windows" key as main modifier
require("config.defaults")
local b = require("config.binds-utils")

local RIGHT = "right"
local LEFT = "left"
local UP = "up"
local DOWN = "down"

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(b.combo(mainMod, "left"), hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(b.combo(mainMod, key), hl.dsp.focus({ workspace = i }))
	hl.bind(b.combo(mainMod, "SHIFT", key), hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- https://wiki.hyprland.org/Configuring/Binds/
hl.bind(mainMod .. " + Q", hl.dsp.window.close(), { description = "Closes (not kill) current window" })
hl.bind(mainMod .. " + ALT + SHIFT + P", hl.dsp.exec_cmd("loginctl terminate-user ''"), { description = "Exits Hyprland by terminating the user sessions" })
hl.bind(mainMod .. " + V", hl.dsp.window.float(), { description = "Switches current window between floating and tiling mode" })
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }), { description = "Toggles current window fullscreen mode" })
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }), { description = "Toggles current window maximize mode" })
hl.bind(mainMod .. " + ALT + F", function()
	local monitor = hl.get_active_monitor() or { width = 1920, height = 1080 }
	hl.dispatch(hl.dsp.window.resize({ x = monitor.width, y = monitor.height }))
	-- bindd = $mainMod ALT, F, Move active window downwards, movewindow, d
	hl.dispatch(hl.dsp.window.center())
end, { description = "Resize window to the size of the screen" })
hl.bind(mainMod .. " + CTRL + F", hl.dsp.layout("movetoroot"), {
	description = "Increase current window to the largest size; Swaps position and size with the current biggest window",
})
hl.bind(mainMod .. " + CTRL + U", hl.dsp.layout("movetoroot"), {
	description = "Increase current window to the largest size; Swaps position and size with the current biggest window",
})
hl.bind(mainMod .. " + P", hl.dsp.window.pin(), { description = "Pin current window (shows on all workspaces)" })
hl.bind(mainMod .. " + U", hl.dsp.layout("togglesplit"), { description = "Toggles current window split mode" })
hl.bind(mainMod .. " + SHIFT + U", hl.dsp.layout("swapsplit"), { description = "Swap current window position within work tree" })
local function cycle_windows()
	hl.dispatch(hl.dsp.window.cycle_next())
	hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end
hl.bind(mainMod .. " + ALT + Tab", cycle_windows, { repeating = true, description = "Cycle between windows" })
hl.bind(mainMod .. " + Tab", cycle_windows, { repeating = true, description = "Cycle between windows" })

-- ======= Programs Shortcuts =======
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(app_launcher .. " &"), { description = "Runs your application launcher" })
hl.bind(mainMod .. " + CTRL + SPACE", hl.dsp.exec_cmd(window_switcher .. " &"), { description = "Runs your window switcher" })
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal .. " &"), { description = "Opens your preferred terminal emulator (" .. terminal .. ")" })
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(file_manager .. " &"), { description = "Opens your preferred filemanager (" .. file_manager .. ")" })
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser .. " &"), { description = "Open your preferred browser (" .. browser .. ")" })
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd(string.format(terminal_preffix .. " --class " .. task_manager .. " -e " .. task_manager .. " &")), {
	description = "Open your preferred task manager (" .. task_manager .. ")",
})
hl.bind(mainMod .. " + O", function()
	hl.dsp.exec_cmd(string.format("%s --class %s %s cd %s; $EDITOR %s & disown", terminal, note_taker, terminal_middlefix, note_vault, terminal_suffix))
	hl.dsp.exec_cmd(string.format(note_taker .. " &"))
end, { description = "Open your preferred note taking app (" .. note_taker .. ")" })
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(string.format("%s $EDITOR %s & disown", terminal_preffix, terminal_suffix)), {
	description = "Open your preferred code editor (" .. os.getenv("EDITOR") .. ")",
})
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd(color_picker .. " -ar"), { description = "Open your preferred color picker (" .. color_picker .. ")" })
hl.bind(mainMod .. " + PERIOD", hl.dsp.exec_cmd(emoji_picker .. " &"), { description = "Open emoji picker (" .. emoji_picker .. ")" })
hl.bind(mainMod .. " + CTRL + V", hl.dsp.exec_cmd(terminal .. " --class clipse -e 'clipse' &"), { description = "Open clipboard history" })
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd(music_player .. " &"), { description = "Open your preferred music player (" .. music_player .. ")" })

-- ======= Commands Shortcuts =======
hl.bind(mainMod .. " + ALT + S", hl.dsp.exec_cmd(terminal .. " -e " .. sync_all_remotes), {
	description = "Syncronize all remote directories with preferred synchronization program",
})

-- ======= Screenshot/Printscreen =======
hl.bind("Print", hl.dsp.exec_cmd(shot_region), { description = "Creates a screenshot of an area" })
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(shot_region), { description = "Creates a screenshot of an area" })
hl.bind("CTRL + Print", hl.dsp.exec_cmd(shot_window), { description = "Creates a screenshot of the active window" })
hl.bind("ALT + Print", hl.dsp.exec_cmd(shot_screen), { description = "Creates a screenshot of the active display" })
-- ======= Screen Recording =======
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd(shot_screen), { description = "Records screen" })

-- ======= System toggles =======
-- hl.bind(mainMod .. " + CTRL + B", hl.dsp.exec_cmd(" rfkill block bluetooth || rfkill unblock bluetooth"), {
-- 	description = "Toggles bluetooth on/off",
-- 	release = true,
-- })
hl.bind(mainMod .. " + ALT + B", hl.dsp.exec_cmd("/home/thiago/.config/hypr/scripts/bluetooth-toggle.sh"), {
	description = "Toggles bluetooth on/off",
	release = true,
})

-- ======= Grouping Windows =======
hl.bind(mainMod .. " +  + G", hl.dsp.group.toggle(), { description = "Toggles  current window group mode (ungroup all related)" })
hl.bind(mainMod .. " + Tab", hl.dsp.group.next(), { description = "Switches to the next window in the group", repeating = true })
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.group.prev(), { description = "Switches to the next window in the group", repeating = true })

-- -- ======= Toggle Gaps =======
-- hl.bind(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd('hyprctl --batch "keyword general:gaps_out 5;keyword general:gaps_in 3"'), {
-- 	description = "Set CachyOS default gaps",
-- })
-- hl.bind(mainMod .. " +  + G", hl.dsp.exec_cmd('hyprctl --batch "keyword general:gaps_out 0;keyword general:gaps_in 0"'), {
-- 	description = "Remove gaps between window",
-- })

-- ======= Volume Control =======
local function raise_volume()
	local raise_volume_cmd =
		"pactl set-sink-volume @DEFAULT_SINK@ +5% && pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\\d+(?=%)' | awk '{if($1>100) system(\"pactl set-sink-volume @DEFAULT_SINK@ 100%\")}' && pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\\d+(?=%)' | awk '{print $1}' | head -1 > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob"
	hl.dispatch(hl.dsp.exec_cmd(raise_volume_cmd))
end
local function lower_volume()
	local lower_volume_cmd =
		"amixer sset Master toggle | sed -En '/\\[on\\]/ s/.*\\[([0-9]+)%\\].*/\\1/ p; /\\[off\\]/ s/.*/0/p' | head -1 > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob"
	hl.dispatch(hl.dsp.exec_cmd(lower_volume_cmd))
end
local function mute_volume()
	local mute_volume_cmd =
		"amixer sset Master toggle | sed -En '/\\[on\\]/ s/.*\\[([0-9]+)%\\].*/\\1/ p; /\\[off\\]/ s/.*/0/p' | head -1 > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob"
	hl.dispatch(hl.dsp.exec_cmd(mute_volume_cmd))
end

hl.bind("XF86AudioRaiseVolume", raise_volume, { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", lower_volume, { repeating = true, locked = true })
hl.bind("XF86AudioMute", mute_volume, { repeating = true, locked = true })

-- ======= Playback Control =======
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { description = "Next track" })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { description = "Toggles play/pause" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { description = "Previous track" })
hl.bind(mainMod .. " + XF86AudioMute", hl.dsp.exec_cmd("playerctl play-pause"), { description = "Toggles play/pause" })
hl.bind(mainMod .. " + XF86AudioRaiseVolume", hl.dsp.exec_cmd("playerctl next"), { description = "Next track" })
hl.bind(mainMod .. " + XF86AudioLowerVolume", hl.dsp.exec_cmd("playerctl previous"), { description = "Previous track" })

-- ======= Screen Brightness =======

-- #Increases brightness +4%
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -l -c backlight|grep -oP \"Device '\\K[^']+\"|xargs -I {} brightnessctl -e -d {} s +4%"))
-- #Decreases brightness -4%
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -l -c backlight|grep -oP \"Device '\\K[^']+\"|xargs -I {} brightnessctl -e -d {} s 4%-"))
hl.bind(mainMod .. " + ALT + P", hl.dsp.exec_cmd("hyprlock"), { description = "Lock the screen" })
hl.bind(mainMod .. " + ALT + W", hl.dsp.exec_cmd("killall -SIGUSR2 waybar"), { description = "Reload/restarts Waybar" })

-- ======= Window Actions =======

-- Move window with mainMod + LMB and dragging
hl.bind(b.combo(mainMod, "mouse:272"), hl.dsp.window.drag(), { drag = true, desc = "Move the window towards a direction" })

-- Move window / focus / workspace towards a direction
-- (arrow keys + vim-style HJKL aliases, just like the original)
local directions = {
	{ dir = "left", preffix = "to the ", keys = { "left", "H" }, suffix = "" },
	{ dir = "right", preffix = "to the ", keys = { "right", "L" }, suffix = "" },
	{ dir = "up", preffix = "", keys = { "up", "K" }, suffix = "wards" },
	{ dir = "down", preffix = "", keys = { "down", "J" }, suffix = "wards" },
}

local function to_dir(direction)
	return direction.preffix .. direction.dir .. direction.suffix
end

for _, d in ipairs(directions) do
	for _, key in ipairs(d.keys) do
		-- Move window towards a direction
		local dir = d.dir:sub(1, 1)
		hl.bind(b.combo(mainMod, "SHIFT", key), hl.dsp.window.move({ direction = dir }), { desc = "Move active window " .. to_dir(d) })

		-- Move window towards a direction and through groups
		hl.bind(b.combo(mainMod, "ALT", key), function()
			hl.dispatch(hl.dsp.window.move({ direction = dir, group_aware = true }))
		end, { desc = "Move active window " .. to_dir(d) })

		-- Move active workspace to the monitor in that direction
		hl.bind(b.combo(mainMod, "CTRL", key), hl.dsp.workspace.move({ monitor = dir }), { desc = "Move active workspace to monitor " .. to_dir(d) })

		-- Move keyboard focus in a direction
		hl.bind(b.combo(mainMod, key), hl.dsp.focus({ direction = dir }), { desc = "Move focus " .. to_dir(d) })
	end
end

hl.bind(b.combo(mainMod, "SHIFT", "slash"), hl.dsp.window.center(), { desc = "Center active window downwards" })

hl.bind(b.combo(mainMod, "CTRL", "Tab"), hl.dsp.focus({ monitor = "+1" }), { desc = "Move focus to next monitor" })
hl.bind(b.combo(mainMod, "ALT", "Tab"), hl.dsp.focus({ monitor = "+1" }), { desc = "Move focus to next monitor" })

-- ---- Resizing windows
-- -- Activate keyboard window resize mode
-- -- https://wiki.hyprland.org/Configuring/Binds/#submaps
-- -- bindd = $mainMod, R, Activates window resizing mode, submap, resize
-- submap = resize
-- bindde = , right, Resize to the right (resizing mode), resizeactive, 30 0
-- bindde = , left, Resize to the left (resizing mode), resizeactive, -30 0
-- bindde = , up, Resize upwards (resizing mode), resizeactive, 0 -30
-- bindde = , down, Resize downwards (resizing mode), resizeactive, 0 30
-- bindde = , l, Resize to the right (resizing mode), resizeactive, 30 0
-- bindde = , h, Resize to the left (resizing mode), resizeactive, -30 0
-- bindde = , k, Resize upwards (resizing mode), resizeactive, 0 -30
-- bindde = , j, Resize downwards (resizing mode), resizeactive, 0 30
-- bindde = , escape, Ends window resizing mode, submap, reset
-- submap = reset
-- -- Quick resize window with keyboard
-- -- !!! added $mainMod here because CTRL + SHIFT is used for word selection in various text editors
-- bindde = $mainMod CTRL SHIFT, right, Resize to the right, resizeactive, 30 0
-- bindde = $mainMod CTRL SHIFT, left, Resize to the left, resizeactive, -30 0
-- bindde = $mainMod CTRL SHIFT, up, Resize upwards, resizeactive, 0 -30
-- bindde = $mainMod CTRL SHIFT, down, Resize downwards, resizeactive, 0 30
-- bindde = $mainMod CTRL SHIFT, l, Resize to the right, resizeactive, 30 0
-- bindde = $mainMod CTRL SHIFT, h, Resize to the left, resizeactive, -30 0
-- bindde = $mainMod CTRL SHIFT, k, Resize upwards, resizeactive, 0 -30
-- bindde = $mainMod CTRL SHIFT, j, Resize downwards, resizeactive, 0 30
-- -- Resize window with mainMod + LMB/RMB and dragging
-- bindm = $mainMod, mouse:273, resizewindow	#Resize the window towards a direction
-- bindm = $mainMod, mouse:272, movewindow		#Drag window
-- ---- Resizing Windows End #

-- ---- Move active window to a workspace with $mainMod + CTRL + [0-9]
-- bindd = $mainMod CTRL, 1, Move window and switch to workspace 1, movetoworkspace, 1
-- bindd = $mainMod CTRL, 2, Move window and switch to workspace 2, movetoworkspace, 2
-- bindd = $mainMod CTRL, 3, Move window and switch to workspace 3, movetoworkspace, 3
-- bindd = $mainMod CTRL, 4, Move window and switch to workspace 4, movetoworkspace, 4
-- bindd = $mainMod CTRL, 5, Move window and switch to workspace 5, movetoworkspace, 5
-- bindd = $mainMod CTRL, 6, Move window and switch to workspace 6, movetoworkspace, 6
-- bindd = $mainMod CTRL, 7, Move window and switch to workspace 7, movetoworkspace, 7
-- bindd = $mainMod CTRL, 8, Move window and switch to workspace 8, movetoworkspace, 8
-- bindd = $mainMod CTRL, 9, Move window and switch to workspace 9, movetoworkspace, 9
-- bindd = $mainMod CTRL, 0, Move window and switch to workspace 10, movetoworkspace, 10
-- bindd = $mainMod CTRL, M, Move window and switch to music workspace, movetoworkspace, special:音楽
-- bindd = $mainMod CTRL, left, Move window and switch to the next workspace, movetoworkspace, -1
-- -- bindd = $mainMod CTRL, H, Move window and switch to the next workspace, movetoworkspace, -1
-- bindd = $mainMod CTRL, right, Move window and switch to the previous workspace, movetoworkspace, +1
-- -- bindd = $mainMod CTRL, L, Move window and switch to the previous workspace, movetoworkspace, +1
-- ---- Same as above, but doesn't switch to the workspace
-- bindd = $mainMod SHIFT, 1, Move window silently to workspace 1, movetoworkspacesilent, 1
-- bindd = $mainMod SHIFT, 2, Move window silently to workspace 2, movetoworkspacesilent, 2
-- bindd = $mainMod SHIFT, 3, Move window silently to workspace 3, movetoworkspacesilent, 3
-- bindd = $mainMod SHIFT, 4, Move window silently to workspace 4, movetoworkspacesilent, 4
-- bindd = $mainMod SHIFT, 5, Move window silently to workspace 5, movetoworkspacesilent, 5
-- bindd = $mainMod SHIFT, 6, Move window silently to workspace 6, movetoworkspacesilent, 6
-- bindd = $mainMod SHIFT, 7, Move window silently to workspace 7, movetoworkspacesilent, 7
-- bindd = $mainMod SHIFT, 8, Move window silently to workspace 8, movetoworkspacesilent, 8
-- bindd = $mainMod SHIFT, 9, Move window silently to workspace 9, movetoworkspacesilent, 9
-- bindd = $mainMod SHIFT, 0, Move window silently to workspace 10, movetoworkspacesilent, 10
-- bindd = $mainMod SHIFT, M, Move window silently to music workspace, movetoworkspacesilent, special:音楽
-- bindd = $mainMod SHIFT, left, Move window silently to the next workspace, movetoworkspacesilent, -1
-- -- bindd = $mainMod SHIFT, H, Move window silently to the next workspace, movetoworkspacesilent, -1
-- bindd = $mainMod SHIFT, right, Move window silently to the previous workspace, movetoworkspacesilent, +1
-- -- bindd = $mainMod SHIFT, L, Move window silently to the previous workspace, movetoworkspacesilent, +1
-- -- Window actions End #
--
-- -- ======= Workspace Actions =======
--
-- -- Switch workspaces with mainMod + [0-9]
-- bindd = $mainMod, 1, Switch to workspace 1, workspace, 1
-- bindd = $mainMod, 2, Switch to workspace 2, workspace, 2
-- bindd = $mainMod, 3, Switch to workspace 3, workspace, 3
-- bindd = $mainMod, 4, Switch to workspace 4, workspace, 4
-- bindd = $mainMod, 5, Switch to workspace 5, workspace, 5
-- bindd = $mainMod, 6, Switch to workspace 6, workspace, 6
-- bindd = $mainMod, 7, Switch to workspace 7, workspace, 7
-- bindd = $mainMod, 8, Switch to workspace 8, workspace, 8
-- bindd = $mainMod, 9, Switch to workspace 9, workspace, 9
-- bindd = $mainMod, 0, Switch to workspace 10, workspace, 10
-- bindd = $mainMod ALT, 1, Move window silently to workspace 1, moveworkspacetomonitor, 1 current
-- bindd = $mainMod ALT, 1, Switch to workspace 1, workspace, 1
-- bindd = $mainMod ALT, 2, Move window silently to workspace 2, moveworkspacetomonitor, 2 current
-- bindd = $mainMod ALT, 2, Switch to workspace 2, workspace, 2
-- bindd = $mainMod ALT, 3, Move window silently to workspace 3, moveworkspacetomonitor, 3 current
-- bindd = $mainMod ALT, 3, Switch to workspace 3, workspace, 3
-- bindd = $mainMod ALT, 4, Move window silently to workspace 4, moveworkspacetomonitor, 4 current
-- bindd = $mainMod ALT, 4, Switch to workspace 4, workspace, 4
-- bindd = $mainMod ALT, 5, Move window silently to workspace 5, moveworkspacetomonitor, 5 current
-- bindd = $mainMod ALT, 5, Switch to workspace 5, workspace, 5
-- bindd = $mainMod ALT, 6, Move window silently to workspace 6, moveworkspacetomonitor, 6 current
-- bindd = $mainMod ALT, 6, Switch to workspace 6, workspace, 6
-- bindd = $mainMod ALT, 7, Move window silently to workspace 7, moveworkspacetomonitor, 7 current
-- bindd = $mainMod ALT, 7, Switch to workspace 7, workspace, 7
-- bindd = $mainMod ALT, 8, Move window silently to workspace 8, moveworkspacetomonitor, 8 current
-- bindd = $mainMod ALT, 8, Switch to workspace 8, workspace, 8
-- bindd = $mainMod ALT, 9, Move window silently to workspace 9, moveworkspacetomonitor, 9 current
-- bindd = $mainMod ALT, 9, Switch to workspace 9, workspace, 9
-- bindd = $mainMod ALT, 0, Move window silently to workspace 10, moveworkspacetomonitor, 10 current
-- bindd = $mainMod ALT, 0, Switch to workspace 10, workspace, 10
-- -- Scroll through existing workspaces with mainMod + , or .
-- -- bindd = $mainMod, PERIOD, Scroll through workspaces incrementally, workspace, e+1
-- -- bindd = $mainMod, COMMA, Scroll through workspaces decrementally, workspace, e-1
-- -- With $mainMod + scroll
-- bindd = $mainMod, mouse_down, Scroll through workspaces incrementally, workspace, e+1
-- bindd = $mainMod, mouse_up, Scroll through workspaces decrementally, workspace, e-1
-- bindd = $mainMod, slash, Switch to the previous workspace, workspace, previous
-- -- Special workspaces (scratchpads)
-- bindd = $mainMod CTRL, equal, Move active window to Special workspace, movetoworkspace, special:特別
-- bindd = $mainMod SHIFT, equal, Move active window silently to Special workspace, movetoworkspacesilent, special:特別
-- bindd = $mainMod, equal, Toggles the Special workspace, togglespecialworkspace, 特別
-- bindd = $mainMod, M, Toggles the Music workspace, togglespecialworkspace, 音楽
-- bindd = $mainMod, F1, Call special workspace scratchpad, togglespecialworkspace, scratchpad
-- bindd = $mainMod ALT SHIFT, F1, Move active window to special workspace scratchpad, movetoworkspacesilent, special:scratchpad
--
-- -- ======= Others =======
-- bindd = $mainMod SHIFT, P, Open color picker, exec, hyprpicker -a
-- -- ======= Additional Settings =======
--
-- -- https://wiki.hyprland.org/Configuring/Binds
-- binds {
--     hide_special_on_workspace_change = true
--     workspace_back_and_forth = false
--     allow_workspace_cycles = true
--     workspace_center_on = true
--     focus_preferred_method = 1
--     movefocus_cycles_fullscreen = true
--     window_direction_monitor_fallback = true
--     disable_keybind_grabbing = true
--     allow_pin_fullscreen = true
--     drag_threshold = 1
-- }

-- ## Resizing windows ##

-- Activate keyboard window resize mode (left commented out, as in the original)
-- hl.bind(combo(mainMod, "R"), hl.dsp.submap("resize"), { desc = "Activates window resizing mode" })

local resizeSteps = {
	{ keys = { "right", "l" }, x = 30, y = 0 },
	{ keys = { "left", "h" }, x = -30, y = 0 },
	{ keys = { "up", "k" }, x = 0, y = -30 },
	{ keys = { "down", "j" }, x = 0, y = 30 },
}

hl.define_submap("resize", function()
	for _, step in ipairs(resizeSteps) do
		for _, key in ipairs(step.keys) do
			hl.bind(key, hl.dsp.window.resize({ x = step.x, y = step.y }), { repeating = true })
		end
	end
	-- Ends window resizing mode
	hl.bind("escape", hl.dsp.submap("reset"))
end)

-- Quick resize window with keyboard
-- (mainMod added since CTRL+SHIFT is used for word selection in text editors)
for _, step in ipairs(resizeSteps) do
	for _, key in ipairs(step.keys) do
		hl.bind(b.combo(mainMod, "CTRL", "SHIFT", key), hl.dsp.window.resize({ x = step.x, y = step.y }), { repeating = true })
	end
end

-- Resize / move window with mainMod + LMB/RMB and dragging
hl.bind(b.combo(mainMod, "mouse:273"), hl.dsp.window.resize(), { drag = true, desc = "Resize the window towards a direction" })
hl.bind(b.combo(mainMod, "mouse:272"), hl.dsp.window.drag(), { drag = true, desc = "Drag window" })
-- ## Resizing Windows End ##

-- Move active window to a workspace with mainMod + CTRL + [0-9]
for i = 1, 10 do
	local key = (i == 10) and "0" or tostring(i)
	local ws = tostring(i == 10 and 10 or i)
	hl.bind(b.combo(mainMod, "CTRL", key), hl.dsp.window.move({ workspace = ws }), { desc = "Move window and switch to workspace " .. ws })
end
hl.bind(b.combo(mainMod, "CTRL", "M"), hl.dsp.window.move({ workspace = "special:音楽" }), { desc = "Move window and switch to music workspace" })
hl.bind(b.combo(mainMod, "CTRL", "left"), hl.dsp.window.move({ workspace = "-1" }), { desc = "Move window and switch to the next workspace" })
hl.bind(b.combo(mainMod, "CTRL", "right"), hl.dsp.window.move({ workspace = "+1" }), { desc = "Move window and switch to the previous workspace" })

-- Same as above, but doesn't switch to the workspace
for i = 1, 10 do
	local key = (i == 10) and "0" or tostring(i)
	local ws = tostring(i == 10 and 10 or i)
	hl.bind(b.combo(mainMod, "SHIFT", key), hl.dsp.window.move({ workspace = ws, follow = false }), { desc = "Move window silently to workspace " .. ws })
end
hl.bind(
	b.combo(mainMod, "SHIFT", "M"),
	hl.dsp.window.move({ workspace = "special:音楽", follow = false }),
	{ desc = "Move window silently to music workspace" }
)
hl.bind(b.combo(mainMod, "SHIFT", "left"), hl.dsp.window.move({ workspace = "-1", follow = false }), { desc = "Move window silently to the next workspace" })
hl.bind(
	b.combo(mainMod, "SHIFT", "right"),
	hl.dsp.window.move({ workspace = "+1", follow = false }),
	{ desc = "Move window silently to the previous workspace" }
)
-- Window actions End #

-- ======= Workspace Actions =======

-- Switch workspaces with mainMod + [0-9]
for i = 1, 10 do
	local key = (i == 10) and "0" or tostring(i)
	local ws = tostring(i == 10 and 10 or i)
	hl.bind(b.combo(mainMod, key), hl.dsp.focus({ workspace = ws }), { desc = "Switch to workspace " .. ws })

	-- Move active workspace to the current monitor and switch to it
	hl.bind(b.combo(mainMod, "ALT", key), function()
		hl.dispatch(hl.dsp.workspace.move({ workspace = ws, monitor = "current" }))
		hl.dispatch(hl.dsp.focus({ workspace = ws }))
	end, { desc = "Move workspace " .. ws .. " to current monitor and switch to it" })
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(b.combo(mainMod, "mouse_down"), hl.dsp.focus({ workspace = "e+1" }), { desc = "Scroll through workspaces incrementally" })
hl.bind(b.combo(mainMod, "mouse_up"), hl.dsp.focus({ workspace = "e-1" }), { desc = "Scroll through workspaces decrementally" })
hl.bind(b.combo(mainMod, "slash"), hl.dsp.focus({ workspace = "previous" }), { desc = "Switch to the previous workspace" })

-- Special workspaces (scratchpads)
hl.bind(b.combo(mainMod, "CTRL", "equal"), hl.dsp.window.move({ workspace = "special:特別" }), { desc = "Move active window to Special workspace" })
hl.bind(
	b.combo(mainMod, "SHIFT", "equal"),
	hl.dsp.window.move({ workspace = "special:特別", follow = false }),
	{ desc = "Move active window silently to Special workspace" }
)
hl.bind(b.combo(mainMod, "equal"), hl.dsp.workspace.toggle_special("特別"), { desc = "Toggles the Special workspace" })
hl.bind(b.combo(mainMod, "M"), hl.dsp.workspace.toggle_special("音楽"), { desc = "Toggles the Music workspace" })
hl.bind(b.combo(mainMod, "F1"), hl.dsp.workspace.toggle_special("scratchpad"), { desc = "Call special workspace scratchpad" })
hl.bind(
	b.combo(mainMod, "ALT", "SHIFT", "F1"),
	hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }),
	{ desc = "Move active window to special workspace scratchpad" }
)

-- ======= Others =======
hl.bind(b.combo(mainMod, "SHIFT", "P"), hl.dsp.exec_cmd("hyprpicker -a"), { desc = "Open color picker" })

-- ======= Additional Settings =======
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
