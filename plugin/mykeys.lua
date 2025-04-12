if vim.g.mykeys_loaded == 1 then
    return
end

vim.g.mykeys_loaded = 1
vim.g.mykeys_log_level = "warn"

local hl = {
    -- "Normal" in the floating windows created by telescope.
    MykeysNormal = { default = true, link = "Normal" },
    MykeysVisual = { default = true, link = "Visual" },
    MykeysBorder = { default = true, link = "MykeysNormal" },
    MykeysTitle = { default = true, link = "MykeysBorder" },
    -- Result hl gorup
    MykeysResultsTitle = { default = true, link = "MykeysTitle" },
    MykeysResultsList = { default = true, link = "MykeysVisual" },
    MykeysResultsNormal = { default = true, link = "MykeysNormal" },
    MykeysResultsBorder = { default = true, link = "MykeysBorder" },

    -- Promt hl group
    MykeysPromptTitle = { default = true, link = "MykeysTitle" },
    MykeysPromptNormal = { default = true, link = "MykeysNormal" },
    MykeysPromptBorder = { default = true, link = "MykeysBorder" },
    MykeysPromptPrefix = { default = true, link = "Identifier" },

}

for k, v in pairs(hl) do
    vim.api.nvim_set_hl(0, k, v)
end
