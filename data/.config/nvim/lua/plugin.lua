local plug_path = [[~/.local/share/nvim/site/autoload/]]
local plug_file = [[plug.vim]]

if vim.fn.globpath(plug_path, plug_file):len() == 0 then
    local repo = [[https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim]]
    local install_cmd = [[silent !curl -fLo ]] .. plug_path .. plug_file .. [[ --create-dirs ]] .. repo

    vim.cmd(install_cmd)

    local pluginmanager = vim.api.nvim_create_augroup("pluginmanager", {clear = true})
    vim.api.nvim_create_autocmd("VimEnter", {
        pattern = '*',
        group = pluginmanager,
        callback = function(opts)
            vim.cmd([[:PlugInstall --sync | source $MYVIMRC]])
        end
    })
end

local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.local/share/nvim/plugged')

Plug('cocopon/iceberg.vim') -- color scheme
Plug('vim-airline/vim-airline')
Plug('vim-airline/vim-airline-themes')
Plug('ryanoasis/vim-devicons')

Plug("neovim/nvim-lspconfig")
Plug("j-hui/fidget.nvim")

-- Autocompletion framework
Plug("hrsh7th/nvim-cmp")
Plug("hrsh7th/cmp-nvim-lsp")
Plug("hrsh7th/cmp-vsnip")

-- sources
Plug("hrsh7th/cmp-path")
Plug("hrsh7th/cmp-buffer")

Plug('hrsh7th/vim-vsnip')
Plug('mrcjkb/rustaceanvim')

vim.call('plug#end')

-- TODO `:PlugInstall/:PlugUpdate` once a day, or if list is mismatch
