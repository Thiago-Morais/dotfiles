local M = {}

<* for name, value in colors *>
M.{{name}} = "rgba({{value.default.hex_stripped}}ff)"
M.{{name}}8 = "rgba({{value.default.hex_stripped}}cc)"
M.{{name}}5 = "rgba({{value.default.hex_stripped}}7f)"
M.{{name}}3 = "rgba({{value.default.hex_stripped}}4c)"
<* endfor *>

return M
