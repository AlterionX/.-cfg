-- Manually maintained list of custom modules.
--
-- idk how fs operations work with lua.
local PACKAGE_LIST = {
    ['config_tinker'] = true,
    ['base'] = true,
    ['plugin'] = true,
    ['airline'] = true,
    ['hardmode'] = true,
    ['nav'] = true,
    ['syntax'] = true,
    ['tabsandspaces'] = true,
    ['search'] = true,
    ['cosmetic'] = true,
    ['folds'] = true,
    ['lsp'] = true,
    ['ai'] = true,
}

-- Vim tinkering shortcuts
vim.keymap.set('n', '<leader>se', ':vsp $MYVIMRC<cr>')
vim.keymap.set('n', '<leader>sv', function()
    print('clearing modules')
    for name, _ in pairs(package.loaded) do
        if PACKAGE_LIST[name] == true then
            print('processing package ' .. name)
            package.loaded[name] = nil
        else
            print('skipping package ' .. name)
        end
    end
    dofile(vim.env.MYVIMRC)
    print('configuration reloaded')
end)
