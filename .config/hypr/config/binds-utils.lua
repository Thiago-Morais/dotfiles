require("config.defaults")

local M = {}

function M.combo(...)
	return table.concat({ ... }, " + ")
end

M.RIGHT = "right"
M.LEFT = "left"
M.UP = "up"
M.DOWN = "down"

M.RIGHT_VIM = "L"
M.LEFT_VIM = "H"
M.UP_VIM = "K"
M.DOWN_VIM = "J"

M.RIGHT_KEYS = { M.RIGHT, M.RIGHT_VIM }
M.LEFT_KEYS = { M.LEFT, M.LEFT_VIM }
M.UP_KEYS = { M.UP, M.UP_VIM }
M.DOWN_KEYS = { M.DOWN, M.DOWN_VIM }

M.DIRECTIONS = {
	{ dir = M.RIGHT, preffix = "to the ", keys = M.RIGHT_KEYS, suffix = "" },
	{ dir = M.LEFT, preffix = "to the ", keys = M.LEFT_KEYS, suffix = "" },
	{ dir = M.UP, preffix = "", keys = M.UP_KEYS, suffix = "wards" },
	{ dir = M.DOWN, preffix = "", keys = M.DOWN_KEYS, suffix = "wards" },
}

function M.to_dir_as_string(direction)
	return direction.preffix .. direction.dir .. direction.suffix
end

return M
