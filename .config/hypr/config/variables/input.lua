---------------
---- INPUT ----
---------------

require("config.defaults")

-- Input wiki https://wiki.hypr.land/Configuring/Basics/Variables/#input
hl.config({
	input = {
		follow_mouse = 2, -- 0|1|2|3
		float_switch_override_focus = 2,
		kb_model = "abnt2",
		kb_layout = "br",
		-- kb_options = grp:alt_shift_toggle,
		numlock_by_default = true,
		repeat_rate = 65,
		repeat_delay = 250,
		sensitivity = 0.4,
		touchpad = {
			natural_scroll = true,
			scroll_factor = 1.5,
		},
	},
})

------------------
---- GESTURES ----
------------------

-- 4-finger horizontal swipe to switch workspaces
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })

-- 3-finger swipe down toggles fullscreen
hl.gesture({ fingers = 3, direction = "down", action = "float" })

-- 3-finger swipe up toggles float/tile
hl.gesture({ fingers = 3, direction = "up", action = "fullscreen" })

-- 3-finger swipe left closes active window
-- hl.gesture({ fingers = 3, direction = "left", action = "close" })

hl.gesture({ fingers = 2, direction = "pinch", action = "resize" })
