-----------------------
---- LOOK AND FEEL ----
-----------------------

local active_border = { colors = { Colors.primary, Colors.secondary }, angle = 45 }
local inactive_border = { colors = { Colors.primary_container, Colors.secondary_container }, angle = 45 }

---@diagnostic disable-next-line: unused-local
local group_active = Colors.tertiary .. " " .. Colors.primary .. " " .. Colors.tertiary .. " 45deg"
---@diagnostic disable-next-line: unused-local
local group_inactive = Colors.tertiary_container .. " " .. Colors.primary_container .. " " .. Colors.tertiary_container .. " 45deg"

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		border_size = 3,
		gaps_in = 5,
		-- TODO Add a shortcut to toggle between gaps on and off
		gaps_out = 0,

		col = {
			active_border = active_border,
			inactive_border = inactive_border,
		},

		layout = "dwindle", -- master|dwindle
		-- Disable cycle trough windows when move focus outside the edge of the workspace
		no_focus_fallback = true,

		-- https://wiki.hyprland.org/Configuring/Variables/#snap
		snap = {
			enabled = true,
		},
	},
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
hl.config({
	decoration = {
		rounding = 4,
		rounding_power = 3,
		active_opacity = 1,
		inactive_opacity = 0.7,
		dim_inactive = true,
		dim_strength = 0.3,
		dim_special = 0.4,

		-- https://wiki.hyprland.org/Configuring/Variables/#blur
		blur = {
			enabled = true,
			size = 2,
			passes = 2, -- more passes = more resource intensive.
			-- ignore_opacity = false
			xray = false,
			special = true,
			new_optimizations = true,
		},

		-- https://wiki.hyprland.org/Configuring/Variables/#shadow
		shadow = {
			enabled = true,
			range = 4,
			render_power = 1,
			color = Colors.shadow,
			offset = { 1.5, 1.5 },
		},
	},
})

hl.config({
	group = {
		-- auto_group = false
		drag_into_group = 2,
		merge_groups_on_drag = false,
		col = {
			border_active = active_border,
			border_inactive = inactive_border,
		},

		-- https://wiki.hypr.land/Configuring/Basics/Variables/#groupbar
		groupbar = {
			font_family = System_font,
			font_size = 14,
			font_weight_active = "bold",
			text_offset = 2,
			text_color = Colors.on_tertiary,
			text_color_inactive = Colors.on_tertiary_container,
			gradients = true,
			height = 14,
			indicator_gap = 0,
			indicator_height = 0,
			-- rounding = 3,
			gradient_rounding = 7,
			-- gradient_round_only_edges = false,
			col = {
				active = Colors.tertiary,
				inactive = Colors.tertiary_container,
			},
			gaps_in = 2,
			gaps_out = 0,
			keep_upper_gap = false,
		},
	},
})

----------------
----  MISC  ----
----------------

-- https://wiki.hypr.land/configuring/core/config-options/#misc
hl.config({
	misc = {
		disable_hyprland_logo = true,
		font_family = System_font,
		splash_font_family = System_font,
		vrr = 2,
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = true,
		enable_swallow = true,
		swallow_regex = ("(%s|Alacritty|Kitty)"):format(Terminal),
		swallow_exception_regex = "wev",
		focus_on_activate = true,
		background_color = Colors.surface,
		on_focus_under_fullscreen = 1,
		-- exit_window_retains_fullscreen = true,
		enable_anr_dialog = false,
	},
})
