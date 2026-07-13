---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier
-- local mainMod = "ALT" -- Sets "Windows" key as main modifier
require("config.defaults")

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
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
-- hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("loginctl terminate-user"), { description = "Exits Hyprland by terminating the user sessions" })
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

-- -- ======= Window Actions =======
-- ---- Move window with mainMod + LMB/RMB and dragging
-- bindd = $mainMod, mouse:272, Move the window towards a direction, movewindow
-- ---- Move window towards a direction
-- bindd = $mainMod SHIFT, left, Move active window to the left, movewindow, l
-- bindd = $mainMod SHIFT, H, Move active window to the left, movewindow, l
-- bindd = $mainMod SHIFT, right, Move active window to the right, movewindow, r
-- bindd = $mainMod SHIFT, L, Move active window to the right, movewindow, r
-- bindd = $mainMod SHIFT, up, Move active window upwards, movewindow, u
-- bindd = $mainMod SHIFT, K, Move active window upwards, movewindow, u
-- bindd = $mainMod SHIFT, down, Move active window downwards, movewindow, d
-- bindd = $mainMod SHIFT, J, Move active window downwards, movewindow, d
-- bindd = $mainMod SHIFT, slash, Center active window downwards, centerwindow
--
-- bindd = $mainMod ALT, left, Move active window to the left, moveoutofgroup, l
-- bindd = $mainMod ALT, left, Move active window to the left, movewindoworgroup, l
-- bindd = $mainMod ALT, H, Move active window to the left, moveoutofgroup, l
-- bindd = $mainMod ALT, H, Move active window to the left, movewindoworgroup, l
-- bindd = $mainMod ALT, right, Move active window to the right, moveoutofgroup, r
-- bindd = $mainMod ALT, right, Move active window to the right, movewindoworgroup, r
-- bindd = $mainMod ALT, L, Move active window to the right, moveoutofgroup, r
-- bindd = $mainMod ALT, L, Move active window to the right, movewindoworgroup, r
-- bindd = $mainMod ALT, up, Move active window upwards, moveoutofgroup, u
-- bindd = $mainMod ALT, up, Move active window upwards, movewindoworgroup, u
-- bindd = $mainMod ALT, K, Move active window upwards, moveoutofgroup, u
-- bindd = $mainMod ALT, K, Move active window upwards, movewindoworgroup, u
-- bindd = $mainMod ALT, down, Move active window downwards, moveoutofgroup, d
-- bindd = $mainMod ALT, down, Move active window downwards, movewindoworgroup, d
-- bindd = $mainMod ALT, J, Move active window downwards, moveoutofgroup, d
-- bindd = $mainMod ALT, J, Move active window downwards, movewindoworgroup, d
--
-- bindd = $mainMod CTRL, left, Move active workspace to monitor to the left, movecurrentworkspacetomonitor, l
-- bindd = $mainMod CTRL, H, Move active workspace to monitor to the left, movecurrentworkspacetomonitor, l
-- bindd = $mainMod CTRL, right, Move active workspace to monitor to the right, movecurrentworkspacetomonitor, r
-- bindd = $mainMod CTRL, L, Move active workspace to monitor to the right, movecurrentworkspacetomonitor, r
-- bindd = $mainMod CTRL, up, Move active workspace to monitor upwards, movecurrentworkspacetomonitor, u
-- bindd = $mainMod CTRL, K, Move active workspace to monitor upwards, movecurrentworkspacetomonitor, u
-- bindd = $mainMod CTRL, down, Move active workspace to monitor downwards, movecurrentworkspacetomonitor, d
-- bindd = $mainMod CTRL, J, Move active workspace to monitor downwards, movecurrentworkspacetomonitor, d
--
-- ---- Move focus with mainMod + arrow keys
-- bindd = $mainMod, left, Move focus to the left, movefocus, l
-- bindd = $mainMod, H, Move focus to the left, movefocus, l
-- bindd = $mainMod, right,  Move focus to the right, movefocus, r
-- bindd = $mainMod, L,  Move focus to the right, movefocus, r
-- bindd = $mainMod, up, Move focus upwards, movefocus, u
-- bindd = $mainMod, K, Move focus upwards, movefocus, u
-- bindd = $mainMod, down, Move focus downwards, movefocus, d
-- bindd = $mainMod, J, Move focus downwards, movefocus, d
-- bindd = $mainMod CTRL, Tab, Move focus to next monitor, focusmonitor, +1
-- bindd = $mainMod ALT, Tab, Move focus to next monitor, focusmonitor, +1
--
-- -- bindd = $mainMod, minus, Toggle hyprwinwrap interactivity, exec, hyprctl dispatch hyprwinwrap_toggle
-- bindd = $mainMod, minus, Toggle hyprwinwrap interactivity, exec, hyprctl dispatch hyprwinwrap_interactivity
--
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
--
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
