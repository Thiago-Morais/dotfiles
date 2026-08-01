local b = require("config.binds-utils")
local _desc = ""

local M = {}

--- For every bind that changes the layout
function M.setup()
	hl.bind(b.combo(MainMod, "Q"), hl.dsp.window.close(), { description = "Closes (not kill) current window" })
	hl.bind(b.combo(MainMod, "V"), hl.dsp.window.float(), { description = "Switches current window between floating and tiling mode" })
	_desc = "Increase current window to the largest size; Swaps position and size with the current biggest window"
	hl.bind(b.combo(MainMod, "CTRL", "F"), hl.dsp.layout("movetoroot"), { description = _desc })
	hl.bind(b.combo(MainMod, "CTRL", "U"), hl.dsp.layout("movetoroot"), { description = _desc })
	hl.bind(b.combo(MainMod, "P"), hl.dsp.window.pin(), { description = "Pin current window (shows on all workspaces)" })
	hl.bind(b.combo(MainMod, "U"), hl.dsp.layout("togglesplit"), { description = "Toggles current window split mode" })
	hl.bind(b.combo(MainMod, "SHIFT", "U"), hl.dsp.layout("swapsplit"), { description = "Swap current window position within work tree" })
	hl.bind(b.combo(MainMod, "mouse:272"), hl.dsp.window.drag(), { drag = true, desc = "Move the window towards a direction" })

	local function move_window_or_focus_towards_direction()
		for _, d in ipairs(b.DIRECTIONS) do
			for _, key in ipairs(d.keys) do
				-- Move window towards a direction
				local dir = d.dir:sub(1, 1)
				_desc = "Move active window " .. b.to_dir_as_string(d)
				hl.bind(b.combo(MainMod, "SHIFT", key), hl.dsp.window.move({ direction = dir }), { desc = _desc })

				-- Move window towards a direction and through groups
				_desc = "Move active window " .. b.to_dir_as_string(d)
				hl.bind(b.combo(MainMod, "ALT", key), hl.dsp.window.move({ direction = dir, group_aware = true }), { desc = _desc })

				-- Move window focus towards a direction
				_desc = "Move focus " .. b.to_dir_as_string(d)
				hl.bind(b.combo(MainMod, key), hl.dsp.focus({ direction = dir }), { desc = _desc })
			end
		end
	end
	move_window_or_focus_towards_direction()

	local function resizing_window()
		local resizeSteps = {
			{ keys = b.RIGHT_KEYS, x = 30, y = 0 },
			{ keys = b.LEFT_KEYS, x = -30, y = 0 },
			{ keys = b.UP_KEYS, x = 0, y = -30 },
			{ keys = b.DOWN_KEYS, x = 0, y = 30 },
		}

		-- Quick resize window with keyboard
		for _, step in ipairs(resizeSteps) do
			for _, key in ipairs(step.keys) do
				hl.bind(b.combo(MainMod, "CTRL", "SHIFT", key), hl.dsp.window.resize({ x = step.x, y = step.y, relative = true }), { repeating = true })
			end
		end

		-- Resize / move window with mainMod + LMB/RMB and dragging
		hl.bind(b.combo(MainMod, "mouse:273"), hl.dsp.window.resize(), { drag = true, desc = "Resize the window towards a direction" })
		hl.bind(b.combo(MainMod, "mouse:272"), hl.dsp.window.drag(), { drag = true, desc = "Drag window" })

		-- Activate keyboard window resize mode (left commented out, as in the original)
		-- hl.bind(b.combo(mainMod, "R"), hl.dsp.submap("resize"), { desc = "Activates window resizing mode" })

		hl.define_submap("resize", function()
			for _, step in ipairs(resizeSteps) do
				for _, key in ipairs(step.keys) do
					hl.bind(key, hl.dsp.window.resize({ x = step.x, y = step.y, relative = true }), { repeating = true })
				end
			end
			hl.bind("escape", hl.dsp.submap("reset"))
		end)
	end
	resizing_window()

	local function cycle_windows()
		hl.dispatch(hl.dsp.window.cycle_next())
		hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
	end
	hl.bind(b.combo(MainMod, "ALT", "Tab"), cycle_windows, { repeating = true, description = "Cycle between windows" })
	hl.bind(b.combo("ALT", "Tab"), cycle_windows, { repeating = true, description = "Cycle between windows" })

	return _desc
end

return M
