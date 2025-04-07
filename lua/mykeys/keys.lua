--- Get mappgin keys logic
--- @module keys
--- @alias M

local utils = require("mykeys.utils")
local config = require("mykeys.config")

local M = {}

local N = {}
local I = {}
local V = {}

local function normalize_keys(mkeys, filter_fn)
    local normalized = {}
    for _, v in ipairs(mkeys) do
        if filter_fn(v) then
            local k = v.lhs or v.rhs
            k = string.gsub(k, " ", "<Space>")
            normalized[#normalized + 1] = { key = k, desc = v.desc or "Give me a description!" }
        end
    end
    return normalized
end

local function filter_mode(mode)
    return function(value)
        return value.mode == mode
    end
end

local function format_key(mk)
    return mk.key .. "\t" .. config.values.results.sep .. " " .. mk.desc
end

local function comparator_key(mk1, mk2)
    return mk1.desc < mk2.desc
end

--- Get all keys for normal,insert and visual mode
--- either global than buffer scope
--- @param bufId integer
--- @return table table collect all mapping grouped by mode
--- in the form {key,desc}
function M.get_keys(bufId)
    local keymap = {}

    local gi_keymap = vim.api.nvim_get_keymap("i")
    keymap[I] = normalize_keys(gi_keymap, filter_mode("i"))

    local gn_keymap = vim.api.nvim_get_keymap("n")
    keymap[N] = normalize_keys(gn_keymap, filter_mode("n"))

    local gv_keymap = vim.api.nvim_get_keymap("v")
    keymap[V] = normalize_keys(gv_keymap, filter_mode("v"))

    if bufId then
        local bi_keymap = vim.api.nvim_buf_get_keymap(bufId, "i")
        utils.append(keymap[I], normalize_keys(bi_keymap, filter_mode("i")))

        local bn_keymap = vim.api.nvim_buf_get_keymap(bufId, "n")
        utils.append(keymap[N], normalize_keys(bn_keymap, filter_mode("n")))

        local bv_keymap = vim.api.nvim_buf_get_keymap(bufId, "v")
        utils.append(keymap[V], normalize_keys(bv_keymap, filter_mode("v")))
    end

    table.sort(keymap[I], comparator_key)
    table.sort(keymap[N], comparator_key)
    table.sort(keymap[V], comparator_key)
    return keymap
end

---Summarize all grouped keys
---@param keys any
---@return table
function M.summarize(keys)
    local bf = {}

    bf[1] = " "
    bf[2] = "Insert Mode"
    bf[3] = " "
    utils.string_buf_append(bf, keys[I], format_key)

    bf[#bf + 1] = " "
    bf[#bf + 1] = "Normal Mode"
    bf[#bf + 1] = " "
    utils.string_buf_append(bf, keys[N], format_key)

    bf[#bf + 1] = " "
    bf[#bf + 1] = "Visual Mode"
    bf[#bf + 1] = " "
    utils.string_buf_append(bf, keys[V], format_key)

    return bf
end

return M;
