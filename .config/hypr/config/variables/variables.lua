---------------------------------
---- VARIABLES CONFIGURATION ----
---------------------------------

-- https://wiki.hyprland.org/Configuring/Variables/#render
hl.config({
	render = {
		direct_scanout = 1,
		-- direct_scanout = 2
	},
	cursor = {
		-- no_warps = true
		-- persistent_warps = true
		-- warp_on_change_workspace = 1
		-- no_hardware_cursors = 0
		no_hardware_cursors = 0,
	},
	ecosystem = {
		no_update_news = true,
		no_donation_nag = true,
	},
})

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
	dwindle = {
		preserve_split = true,
		special_scale_factor = 0.8,
		split_bias = 1,
	},
})

hl.config({
	-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
	master = {
		new_status = "master",
		special_scale_factor = 0.8,
	},
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
	scrolling = {
		fullscreen_on_one_column = true,
	},
})
