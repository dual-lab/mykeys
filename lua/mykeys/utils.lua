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
---@return array
function M.init_array(a, n, value)
    for i = 1, n, 1 do
        a[i] = value
    end

    return a
end

return M
