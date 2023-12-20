vim.opt.compatible = false
vim.opt.hidden = true

vim.opt.history = 1000
vim.opt.undolevels = 1000
vim.opt.backup = false

vim.opt.visualbell = true -- no bell sound

vim.opt.wildignore = { '*.swp', '*.bak', '*.pyc', '*.class' }

-- Unbind paste for visual congruence:
-- 1) c-v is visual block
-- 2) s-v is visual line
-- 3) v is visual
vim.keymap.set('n', '<c-v>', '<c-q>')
vim.keymap.set('n', '<c-q>', '<nop>')
