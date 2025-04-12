local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require "telescope.actions"

local my_keys_config = require("mykeys.config")
local keys = require("mykeys.keys")

return function(opts)
    opts = opts or {}
    my_keys_config.set_defaults(opts)
    pickers.new(opts, {
        prompt_title = my_keys_config.values.prompt.title,
        finder = finders.new_table {
            results = keys.summarize(keys.get_keys(vim.api.nvim_get_current_buf()))
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function (prompt_bfrn, map)
            actions.select_default:replace(function ()
                actions.close(prompt_bfrn)
            end)
            return true
        end
    }):find()
end
