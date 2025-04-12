---Module scroller
---@module scroller
---@alias M

local log = require("mykeys.dev").log

local M = {}

local Modes = {
    ASC = "asc",
    DESC = "desc"
}

---@class Scroller
---@field windid integer
---@field bufrid integer
---@field mode string
---@field cap integer
---@field limit integer
---@field ns_id integer
local Base = {
    windid = 0,
    bufrid = 0,
    mode = Modes.DESC,
    cap = 0,
    limit = 0,
    ns_id = 0
}

---Scroller constructor
---@param klass table
---@return Scroller
function M.New(klass)
    local o = klass or {}
    o["_id_mark"] = nil
    Base.__index = Base
    setmetatable(o, Base)
    return o
end

---Attach scroller
---@param limit integer
function Base:refresh(limit)
    self.limit = limit or self.cap
    local line = 1
    if self.mode == Modes.DESC then
        line = self.cap - 1
    end
    vim.api.nvim_win_set_cursor(self.windid, { line, 0 })

    self._id_mark = vim.api.nvim_buf_set_extmark(
        self.bufrid, self.ns_id, line, 0, {
            line_hl_group = "MykeysResultsList",
        }
    )
end

M.Modes = Modes


return M
