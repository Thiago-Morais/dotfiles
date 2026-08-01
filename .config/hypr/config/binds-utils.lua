local def = require("config.defaults")

local M = {}

function M.combo(...)
	return table.concat({ ... }, " + ")
end

return M
