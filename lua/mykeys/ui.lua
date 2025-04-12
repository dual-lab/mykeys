--- Ui module for toggle floating windows
--- @module ui
--- @alias M
---

local popup = require("plenary.popup")
local log = require("mykeys.dev").log
local keys = require("mykeys.keys")
local config = require("mykeys.config")
local finder = require("mykeys.ui.finder")

local M = {}

local mykeys_wind_id
local mykeys_buff_id
local mykeys_group_name = "MykeysGroup"
local mykeys_wind_prompt_id
local mykeys_buff_prompt_id
local mykeys_finder

local function create_window(opts)
    log.trace("create_window()")

    local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
    local buf = vim.api.nvim_create_buf(false, true)

    local win_id, win_opt = popup.create(buf, {
        title = opts.title,
        line = opts.line,
        col = opts.col,
        minwidth = opts.width,
        minheight = opts.height,
        borderchars = borderchars,
        highlight = "MyKeysResultsNormal",
        borderhighlight = "MyKeysResultsBorder",
        titlehighlight = "MyKeysResultsTitle",
        focusable = true
    })

    return {
        buf = buf,
        win_id = win_id,
        win_opt = win_opt,
    }
end

local function close_window()
    vim.api.nvim_clear_autocmds({
        group = mykeys_group_name,
        event = "BufLeave",
        buffer = mykeys_buff_prompt_id
    })

    if vim.api.nvim_win_is_valid(mykeys_wind_id) then
        vim.api.nvim_win_close(mykeys_wind_id, true)
    end

    if vim.api.nvim_win_is_valid(mykeys_wind_prompt_id) then
        vim.api.nvim_win_close(mykeys_wind_prompt_id, true)
    end

    mykeys_wind_id = nil
    mykeys_wind_prompt_id = nil

    -- Suppress the buffer deleted message for those with &report<2
    local start_report = vim.o.report
    if start_report < 2 then
        vim.o.report = 2
    end

    if vim.api.nvim_buf_is_valid(mykeys_buff_id)
        and vim.api.nvim_buf_is_loaded(mykeys_buff_id) then
        vim.schedule(function()
            vim.api.nvim_buf_delete(mykeys_buff_id, { force = true })
            mykeys_buff_id = nil
        end)
    end

    if vim.api.nvim_buf_is_valid(mykeys_buff_prompt_id)
        and vim.api.nvim_buf_is_loaded(mykeys_buff_prompt_id) then
        vim.schedule(function()
            vim.api.nvim_buf_delete(mykeys_buff_prompt_id, { force = true })
            mykeys_buff_prompt_id = nil
            mykeys_finder = nil
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

    local width = config.values.results.width
    local height = config.values.results.height
    local line = math.floor(((vim.o.lines - height) / 2) - 1)
    local col = math.floor((vim.o.columns - width) / 2)

    local win = create_window({
        title = config.values.results.title,
        line = line,
        col = col,
        width = config.values.results.width,
        height = config.values.results.height
    })

    mykeys_buff_id = win.buf
    mykeys_wind_id = win.win_id

    local sum_keys = keys.summarize(mapped_keys)

    vim.api.nvim_win_set_option(mykeys_wind_id, "number", false)
    vim.api.nvim_buf_set_name(mykeys_buff_id, "mykeys-list")
    vim.api.nvim_buf_set_lines(mykeys_buff_id, 0, #sum_keys, false, sum_keys)
    vim.api.nvim_buf_set_option(mykeys_buff_id, "filetype", "mykeys")
    vim.api.nvim_buf_set_option(mykeys_buff_id, "buftype", "nowrite")
    vim.api.nvim_buf_set_option(mykeys_buff_id, "bufhidden", "delete")
    vim.api.nvim_buf_set_option(mykeys_buff_id, "tabstop", 1)
    vim.api.nvim_buf_set_option(mykeys_buff_id, "wrap", config.values.results.wrap)

    local prompt = create_window({
        title = config.values.prompt.title,
        line = line + height + 2,
        col = col,
        width = config.values.prompt.width,
        height = config.values.prompt.height,
    })

    mykeys_wind_prompt_id = prompt.win_id
    mykeys_buff_prompt_id = prompt.buf

    vim.api.nvim_buf_set_option(mykeys_buff_prompt_id, "tabstop", 1)
    vim.api.nvim_buf_set_option(mykeys_buff_prompt_id, "buftype", "prompt")
    vim.api.nvim_buf_set_option(mykeys_buff_prompt_id, "wrap", true)

    vim.fn.prompt_setprompt(mykeys_buff_prompt_id, config.values.prompt.prefix)

    local mode = vim.fn.mode()
    local k = mode ~= "n" and "<ESC>A" or "A"

    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(k, true, false, true),
        "ni", true
    )

    vim.api.nvim_create_augroup(mykeys_group_name, {})
    vim.api.nvim_create_autocmd("BufLeave", {
        buffer = mykeys_buff_prompt_id,
        group = mykeys_group_name,
        nested = true,
        once = true,
        callback = function()
            require("mykeys.ui").toggle()
        end
    })
    mykeys_finder = finder.New({
        prompt_prefix = config.values.prompt.prefix,
        prompt_windid = mykeys_wind_prompt_id,
        prompt_bufrn = mykeys_buff_prompt_id,
        result_windid = mykeys_wind_id,
        result_bufrn = mykeys_buff_id,
        data = sum_keys,
        onFilter = function(value, input)
            return string.find(value, input) ~= nil
        end
    })
    vim.api.nvim_win_set_cursor(mykeys_wind_id, { #sum_keys - 1, 0 })
    mykeys_finder:attach()
    --TODO liste on buffer prompt change
end

return M
