--- Utils module
--- @module utils
--- @alias M
---

local M = {}

--- function to append an array to another
--- @param a1 table
--- @param a2 table
function M.append(a1, a2)
    for _, value in ipairs(a2) do
        table.insert(a1, value)
    end
end

---append to a string buffer
---@param buff table
---@param values table
---@param fn function  format function
---@return table
function M.string_buf_append(buff, values, fn)
    for _, value in ipairs(values) do
        buff[#buff + 1] = fn(value)
    end
    return buff
end

---Initialize and array with a default value
---@param a table
---@param n integer
---@param value any
---@return table
function M.init_array(a, n, value)
    for i = 1, n, 1 do
        a[i] = value
    end

    return a
end

---Util function to set multiple mapping
---@param mapping table<table<1|2|3|4>>
function M.set_mapping(mapping)
    for _, value in pairs(mapping) do
        vim.keymap.set(
            value[2],
            value[1],
            value[3],
            value[4]
        )
    end
end

return M
