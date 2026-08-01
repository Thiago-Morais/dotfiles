local b = require("config.binds-utils")

local M = {}

function M.setup()
	for i = 1, 10 do
		local key = i % 10 -- 10 maps to key 0
		-- Move workspace i to the current monitor and switch to it
		hl.bind(b.combo(MainMod, "ALT", key), function()
			hl.dispatch(hl.dsp.workspace.move({ workspace = i, monitor = "current" }))
			hl.dispatch(hl.dsp.focus({ workspace = i }))
		end, { desc = "Move workspace " .. i .. " to current monitor and switch to it" })
	end

	-- Move window / focus / workspace towards a direction
	for _, d in ipairs(b.DIRECTIONS) do
		for _, key in ipairs(d.keys) do
			local dir = d.dir:sub(1, 1)
			-- Move active workspace to the monitor in that direction
			hl.bind(
				b.combo(MainMod, "CTRL", key),
				hl.dsp.workspace.move({ monitor = dir }),
				{ desc = "Move active workspace to monitor " .. b.to_dir_as_string(d) }
			)
		end
	end

	hl.bind(b.combo(MainMod, "CTRL", "Tab"), hl.dsp.focus({ monitor = "+1" }), { desc = "Move focus to next monitor" })
	hl.bind(b.combo(MainMod, "ALT", "Tab"), hl.dsp.focus({ monitor = "+1" }), { desc = "Move focus to next monitor" })
end

return M
