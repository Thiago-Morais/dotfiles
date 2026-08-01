local M = {}

function M.combo(...)
	return table.concat({ ... }, " + ")
end

return M
