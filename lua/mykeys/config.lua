--- Configuration module
--- @module config
--- @alias M
---

local M = {}

local config = {}

local function append(name, value, default)
    if type(default) == "table" then
        local group = {}
        for key, v in pairs(default) do
            if value[key] == nil then
                group[key] = v
            else
                group[key] = value[key]
            end
        end
        config[name] = group
    else
        config[name] = value or default
    end
end
---Set default config
---@param opt any
function M.set_defaults(opt)
    local results = {
        wrap = true,
        title = "mykeys",
        width = 60,
        height = 10,
        sep = "❱"
    }
    append("results", opt.results or {}, results)

    local prompt = {
        title = "seearch",
        width = 60,
        height = 1,
        prefix = "> "
    }
    append("prompt", opt.prompt or {}, prompt)

    M.values = vim.deepcopy(config)
end

return M
