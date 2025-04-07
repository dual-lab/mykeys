---Dev module
---@module dev
---@alias M
---


local M = {}

M.log = require("plenary.log").new({
    plugin = "mykeys",
    use_console = "async",
    use_file = true,
    level = vim.env.MYEYS_LOG or vim.g.mykeys_log_level
})

return M
