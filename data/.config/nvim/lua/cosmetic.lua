-- cosmetic
vim.opt.listchars.tab = '▸\\'
vim.opt.listchars.eol = '¬'
vim.opt.title = true

vim.opt.modelines = 0

-- numbering
vim.opt.number = true
vim.opt.numberwidth = 5
vim.opt.ruler = true
vim.opt.wrap = false -- don't wrap lines past edge

-- theming
vim.opt.background = dark
vim.g.colors_name = iceberg
vim.cmd [[ colorscheme iceberg ]]
-- override several colors for autocomplete
vim.api.nvim_set_hl(0, "CmpItemAbbr", { fg = "#787878" })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#d9d9d9" })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#d0d0d0" })
vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#800000" })
vim.api.nvim_set_hl(0, "CmpItemKind", { fg = "#84a0c6" })
