require("config.defaults")
local b = require("config.binds-utils")

hl.config({ decoration = { blur = { new_optimizations = false } } })

-- class is an EXACT match and NOT a regex! Use `hyprctl clients` to find it.
-- You may match on `class` and/or `title`. pos_*/size_* are percentages.
-- if hl.plugin.hyprwinwrap ~= nil then
hl.plugin.hyprwinwrap.window({
	class = background_video_class,
	title = background_video_title,
	layer = 0,
	pos_x = 0,
	pos_y = 0,
	size_x = 100,
	size_y = 100,
})
-- end

hl.bind(b.combo(mainMod, "minus"), function()
	if hl.get_window("class:" .. background_video_class) then
		hl.plugin.hyprwinwrap.focus(background_video_class)
	end
end)
