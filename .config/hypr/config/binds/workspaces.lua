local b = require("config.binds-utils")
local _desc = ""

local M = {}

function M.setup()
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
	end

	-- Special workspaces (scratchpads)
	do
		local ws = "special:音楽"
		_desc = "Move window and switch to music workspace"
		hl.bind(b.combo(MainMod, "CTRL", "M"), window_move({ workspace = ws }), { desc = _desc })
		_desc = "Move window silently to music workspace"
		hl.bind(b.combo(MainMod, "SHIFT", "M"), window_move({ workspace = ws, follow = false }), { desc = _desc })
		_desc = "Toggles the Music workspace"
		hl.bind(b.combo(MainMod, "M"), hl.dsp.workspace.toggle_special("音楽"), { desc = _desc })

		ws = "special:特別"
		_desc = "Move active window to Special workspace"
		hl.bind(b.combo(MainMod, "CTRL", "equal"), window_move({ workspace = ws }), { desc = _desc })
		_desc = "Move active window silently to Special workspace"
		hl.bind(b.combo(MainMod, "SHIFT", "equal"), window_move({ workspace = ws, follow = false }), { desc = _desc })
		_desc = "Toggles the Special workspace"
		hl.bind(b.combo(MainMod, "equal"), hl.dsp.workspace.toggle_special("特別"), { desc = _desc })

		ws = "-1"
		_desc = "Move window and switch to the next workspace"
		hl.bind(b.combo(MainMod, "CTRL", b.LEFT), window_move({ workspace = ws }), { desc = _desc })
		_desc = "Move window silently to the next workspace"
		hl.bind(b.combo(MainMod, "SHIFT", b.LEFT), window_move({ workspace = ws, follow = false }), { desc = _desc })
		ws = "+1"
		_desc = "Move window and switch to the previous workspace"
		hl.bind(b.combo(MainMod, "CTRL", b.RIGHT), window_move({ workspace = ws }), { desc = _desc })
		_desc = "Move window silently to the previous workspace"
		hl.bind(b.combo(MainMod, "SHIFT", b.RIGHT), window_move({ workspace = ws, follow = false }), { desc = _desc })
	end

	-- Scroll through existing workspaces with mainMod + scroll
	hl.bind(b.combo(MainMod, "mouse_down"), hl.dsp.focus({ workspace = "e+1" }), { desc = "Scroll through workspaces incrementally" })
	hl.bind(b.combo(MainMod, "mouse_up"), hl.dsp.focus({ workspace = "e-1" }), { desc = "Scroll through workspaces decrementally" })
	hl.bind(b.combo(MainMod, "slash"), hl.dsp.focus({ workspace = "previous" }), { desc = "Switch to the previous workspace" })
end

return M
