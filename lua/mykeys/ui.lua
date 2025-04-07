--- Ui module for toggle floating windows
--- @module ui
--- @alias M
---

local popup = require("plenary.popup")
local log = require("mykeys.dev").log
local keys = require("mykeys.keys")
local config = require("mykeys.config")

local M = {}

local mykeys_wind_id
local mykeys_buff_id
local mykeys_group_name = "MykeysGroup"

local function create_window()
    log.trace("create_window()")
    local width = config.values.results.width
    local height = config.values.results.height
    local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
    local buf = vim.api.nvim_create_buf(false, true)

    local win_id = popup.create(buf, {
        title = "mykeys",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
        highlight = "MyKeysResultsNormal",
        borderhighlight = "MyKeysResultsBorder",
        titlehighlight = "MyKeysResultsTitle",
    })

    return {
        buf = buf,
        win_id = win_id,
    }
end

local function close_window()
    if vim.api.nvim_win_is_valid(mykeys_wind_id) then
        vim.api.nvim_win_close(mykeys_wind_id, true)
    end

    mykeys_wind_id = nil

    -- Suppress the buffer deleted message for those with &report<2
    local start_report = vim.o.report
    if start_report < 2 then
        vim.o.report = 2
    end

    if vim.api.nvim_buf_is_valid(mykeys_buff_id)
        and vim.api.nvim_buf_is_loaded(mykeys_buff_id) then
        vim.api.nvim_clear_autocmds({
            group = mykeys_group_name,
            event = "BufLeave",
            buffer = mykeys_buff_id
        })
        vim.schedule(function()
            vim.api.nvim_buf_delete(mykeys_buff_id, { force = true })
            mykeys_buff_id = nil
        end)
    end

    if start_report < 2 then
        vim.o.report = start_report
    end
end

---Toggle popup keys
---@param mapped_keys table
function M.toggle(mapped_keys)
    log.trace("ui toggle")
    if mykeys_wind_id ~= nil then
        close_window()
        return
    end

    local win = create_window()

    mykeys_buff_id = win.buf
    mykeys_wind_id = win.win_id

    local sum_keys = keys.summarize(mapped_keys)

    vim.api.nvim_win_set_option(mykeys_wind_id, "number", true)
    vim.api.nvim_buf_set_name(mykeys_buff_id, "mykeys-list")
    vim.api.nvim_buf_set_lines(mykeys_buff_id, 0, #sum_keys, false, sum_keys)
    vim.api.nvim_buf_set_option(mykeys_buff_id, "filetype", "mykeys")
    vim.api.nvim_buf_set_option(mykeys_buff_id, "buftype", "nowrite")
    vim.api.nvim_buf_set_option(mykeys_buff_id, "bufhidden", "delete")
    vim.api.nvim_buf_set_option(mykeys_buff_id, "tabstop", 1)
    vim.api.nvim_buf_set_option(mykeys_buff_id, "wrap", config.values.results.wrap)
    vim.api.nvim_buf_set_option(mykeys_buff_id, "modifiable", false)


    vim.api.nvim_create_augroup(mykeys_group_name, {})
    vim.api.nvim_create_autocmd("BufLeave", {
        buffer = mykeys_buff_id,
        group = mykeys_group_name,
        nested = true,
        once = true,
        callback = function()
            require("mykeys.ui").toggle()
        end
    })

    --TODO create prompt windows
    --TODO liste on buffer prompt change
end

return M
