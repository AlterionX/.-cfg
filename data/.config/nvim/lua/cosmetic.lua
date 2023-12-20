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

-- background
vim.opt.background = dark
vim.g.colors_name = iceberg
vim.cmd [[ colorscheme iceberg ]]
