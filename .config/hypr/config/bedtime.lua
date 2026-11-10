-- Bedtime escalation, driven by $HOME/.config/hypr/scripts/bedtime.sh
-- The script only writes the current level to a state file. This module reads it on every
-- config load, so reloads (wpaperd/matugen rewriting colors.lua, monitor layout changes)
-- reapply the level instead of wiping it like `hyprctl eval` changes would be.

local state_dir = os.getenv("XDG_STATE_HOME") or (os.getenv("HOME") .. "/.local/state")
local level_file = state_dir .. "/bedtime/level"
local shader_dir = os.getenv("HOME") .. "/.config/hypr/shaders/bedtime/"

local NIGHT_REFRESH_RATE = 60
local SHADER_BY_LEVEL = {
	[2] = "grayscale.frag",
	[3] = "grayscale-dim.frag",
	[4] = "grayscale-washed.frag",
}
local MAX_SHADER_LEVEL = 4

local function read_level()
	local file = io.open(level_file, "r")
	if not file then
		return 0
	end
	local level = tonumber(file:read("l")) or 0
	file:close()
	return level
end

local function lower_refresh_rate()
	for _, monitor in ipairs(hl.get_monitors()) do
		local rate = monitor.refresh_rate or monitor.refreshRate
		-- Skipping monitors already at the night rate avoids triggering another layout change
		if not rate or rate > NIGHT_REFRESH_RATE + 1 then
			local has_position = monitor.x and monitor.y
			hl.monitor({
				output = monitor.name,
				mode = ("%dx%d@%d"):format(monitor.width, monitor.height, NIGHT_REFRESH_RATE),
				position = has_position and (monitor.x .. "x" .. monitor.y) or "auto",
				scale = monitor.scale,
			})
		end
	end
end

local function apply(level)
	if level >= 1 then
		lower_refresh_rate()
	end
	if level >= 2 then
		local shader = SHADER_BY_LEVEL[math.min(level, MAX_SHADER_LEVEL)]
		hl.config({ decoration = { screen_shader = shader_dir .. shader } })
	end
	if level >= 3 then
		hl.config({ animations = { enabled = false } })
	end
end

local ok, level = pcall(read_level)
if ok and level > 0 then
	apply(level)
end
