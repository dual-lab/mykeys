---Finder UI module
---@module finder
---@alias M
---

local utils = require("mykeys.utils")
local log = require("mykeys.dev").log

local M = {}

---@class FinderBase
---@field prompt_bufrn integer
---@field result_windid integer
---@field data table
---@field prompt_prefix string
---@field prompt_windid integer
---@field result_bufrn integer
---@field _buf_data table
local Base = {
    prompt_bufrn = 0,
    prompt_prefix = "",
    prompt_windid = 0,
    result_windid = 0,
    result_bufrn = 0,
    data = {},
    onFilter = function(v, i)
        --to nothing
    end
}

---Create baseFinder class
---@param opt table<integer,integer,table,function>
---@return FinderBase
function M.New(opt)
    local o = opt or {}
    o["_buf_data"] = utils.init_array({}, #opt.data, "")
    Base.__index = Base
    setmetatable(o, Base)
    return o
end

---attach finder
function Base:attach()
    log.trace("Base:attach()")
    vim.api.nvim_buf_attach(self.prompt_bufrn, false, {
        on_lines = function(...)
            self:on_line(...)
        end,
        on_detach = function()
            self:on_detach()
        end
    })
end

---handle on line callback
---@param ... table<string,integer,...>
function Base:on_line(...)
    log.trace(...)
    vim.schedule(function()
        local cursor = vim.api.nvim_win_get_cursor(self.prompt_windid)[1] - 1
        local input = vim.api.nvim_buf_get_lines(
            self.prompt_bufrn,
            cursor,
            cursor + 1, false
        )[1]:sub(#self.prompt_prefix + 1)
        if #input == 0 then
            vim.api.nvim_buf_set_lines(self.result_bufrn,
                0,
                -1,
                false,
                self.data)
            return
        end
        local count_top = 1
        local count_bottom = #self._buf_data
        for _, value in ipairs(self.data) do
            if self.onFilter(value, input) then
                self._buf_data[count_bottom] = value
                count_bottom = count_bottom - 1
            else
                self._buf_data[count_top] = ""
                count_top = count_top + 1
            end
        end
        vim.api.nvim_buf_set_lines(self.result_bufrn, 0, -1, false, self._buf_data)
    end)
end

---handle on detach callback
function Base:on_detach()
    log.trace("on_detach")
end

return M
