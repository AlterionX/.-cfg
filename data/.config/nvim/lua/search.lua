-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- highlight removal
vim.keymap.set('n', '<esc>', ':nohl<cr>', {silent = true})
