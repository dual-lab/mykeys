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
    o["_current_pos"] = nil
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
        self.limit = self.cap - self.limit
    end
    self:_set_current_pos(line)
end

---Shift current posistion
---@param line integer
function Base:shift_position(line)
    local pos = self._current_pos + line
    if pos >= self.cap then
        pos = self.limit
    end

    if pos < self.limit then
        pos = self.cap - 1
    end
    self:_set_current_pos(pos)
end

function Base:_set_current_pos(line)
    self._current_pos = line
    vim.api.nvim_win_set_cursor(self.windid, { self._current_pos, 0 })

    self._id_mark = vim.api.nvim_buf_set_extmark(
        self.bufrid, self.ns_id, self._current_pos, 0, {
            line_hl_group = "MykeysResultsList", id = self._id_mark
        }
    )
end

M.Modes = Modes

return M
