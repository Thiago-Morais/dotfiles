hl.config({
	decoration = {
		blur = {
			enabled = false,
		},
	},
})

hl.window_rule({ opacity = 0.85, match = { fullscreen = 0 } })
hl.window_rule({ opacity = 0.75, match = { fullscreen = 0 } })
-- hl.window_rule({ opacity = 0.70, match = { fullscreen = 0 } })
