--- mykeys module nvim plugin to list all your mapped keys
---
--- MIT License
---
--- ======================================================
--- @module  mykeys
--- @alias M
---
---
local keys = require("mykeys.keys")
local log = require("mykeys.dev").log
local ui = require("mykeys.ui")

local M = {}

local function create_buffer()

end

---Toggle show mapping keys
function M.toggle()
    log.trace("toggle()")

    local curr_buf_id = vim.api.nvim_get_current_buf()
    local mapped_keys = keys.get_keys(curr_buf_id)

    ui.toggle(mapped_keys)
end

--- setup the plugin
function M.setup(opt)
    log.trace("setup()")

    local o = opt or {}
    require("mykeys.config").set_defaults(o)
end

return M
