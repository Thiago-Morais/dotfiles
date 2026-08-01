local M = {}

function M.setup()
	-- ======= Playback Control =======
	hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { description = "Toggles play/pause", locked = true })
	hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { description = "Toggles play/pause", locked = true })
	hl.bind(MainMod .. " + XF86AudioMute", hl.dsp.exec_cmd("playerctl play-pause"), { description = "Toggles play/pause", locked = true })
	hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { description = "Next track", locked = true })
	hl.bind(MainMod .. " + XF86AudioRaiseVolume", hl.dsp.exec_cmd("playerctl next"), { description = "Next track", locked = true })
	hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { description = "Previous track", locked = true })
	hl.bind(MainMod .. " + XF86AudioLowerVolume", hl.dsp.exec_cmd("playerctl previous"), { description = "Previous track", locked = true })
end

return M
