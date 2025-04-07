if vim.g.mykeys_loaded == 1 then
    return
end

vim.g.mykeys_loaded = 1
vim.g.mykeys_log_level = "warn"

local hl = {
    -- "Normal" in the floating windows created by telescope.
    MykeysNormal = { default = true, link = "Normal" },
    MykeysResultsNormal = { default = true, link = "TelescopeNormal" },
    MykeysBorder = { default = true, link = "TelescopeNormal" },
    MykeysResultsBorder = { default = true, link = "TelescopeBorder" },
    MykeysTitle = { default = true, link = "TelescopeBorder" },
    MykeysResultsTitle = { default = true, link = "TelescopeTitle" },
}

for k, v in pairs(hl) do
  vim.api.nvim_set_hl(0, k, v)
end
