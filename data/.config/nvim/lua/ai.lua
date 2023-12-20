local greetings = vim.api.nvim_create_augroup('greetings', {clear = true})
vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    group = greetings,
    callback = function(opts)
    print(">^.^< Welcome back >^.^<")
    end
})
