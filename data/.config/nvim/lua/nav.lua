-- better window nav
vim.keymap.set('n', '<c-s-w>', '<nop>')
vim.keymap.set('n', '<c-w>', '<nop>')
vim.keymap.set('n', '<c-h>', '<c-w><c-h>')
vim.keymap.set('n', '<c-j>', '<c-w><c-j>')
vim.keymap.set('n', '<c-k>', '<c-w><c-k>')
vim.keymap.set('n', '<c-l>', '<c-w><c-l>')

-- tab navigation
vim.keymap.set({'n', 'i'}, '<m-h>', ':tabprev<cr>')
vim.keymap.set({'n', 'i'}, '<m-j>', ':tablast<cr>')
vim.keymap.set({'n', 'i'}, '<m-k>', ':tabfirst<cr>')
vim.keymap.set({'n', 'i'}, '<m-l>', ':tabnext<cr>')

-- split directions
vim.opt.splitbelow = true
vim.opt.splitright = true
