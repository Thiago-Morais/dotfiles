local M = {}

function M.setup()
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
end

return M
