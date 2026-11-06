require("config.defaults")
local b = require("config.binds-utils")

hl.config({ decoration = { blur = { new_optimizations = false } } })

-- class is an EXACT match and NOT a regex! Use `hyprctl clients` to find it.
-- You may match on `class` and/or `title`. pos_*/size_* are percentages.
-- if hl.plugin.hyprwinwrap ~= nil then
local class_name = Background_video_class
local title_name = Background_video_title
hl.plugin.hyprwinwrap.window({ class = class_name, title = title_name, layer = 0, pos_x = 0, pos_y = 0, size_x = 100, size_y = 100 })
hl.plugin.hyprwinwrap.window({ class = class_name .. "2", title = title_name .. "2", layer = 1, pos_x = 0, pos_y = 0, size_x = 100, size_y = 100 })

hl.bind(b.combo(MainMod, "minus"), function()
	if hl.get_window("class:" .. class_name) then
		hl.plugin.hyprwinwrap.focus(class_name)
	end
	if hl.get_window("title:" .. title_name) then
		hl.plugin.hyprwinwrap.focus(title_name)
	end
	if hl.get_window("class:" .. class_name .. "2") then
		hl.plugin.hyprwinwrap.focus(class_name .. "2")
	end
	if hl.get_window("title:" .. title_name .. "2") then
		hl.plugin.hyprwinwrap.focus(title_name .. "2")
	end
end)

hl.window_rule({
	match = { class = class_name },
	border_size = 0,
	no_dim = 1,
	opaque = 1,
	float = 1,
	center = 1,
	rounding = 0,
	size = { "monitor_w", "monitor_h" },
})
hl.window_rule({
	match = { title = title_name },
	border_size = 0,
	no_dim = 1,
	opaque = 1,
	float = 1,
	center = 1,
	rounding = 0,
	size = { "monitor_w", "monitor_h" },
})
