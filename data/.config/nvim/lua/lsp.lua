local progress_tracker = require("fidget")
local cmp = require("cmp")

progress_tracker.setup({})

function was_whitespace()
    local col = vim.fn.col('.') - 1

    if col <= 0 then
        return true
    end

    local curr_line = vim.fn.getline('.')
    local prev_char = curr_line:sub(col, col)

    local is_match = prev_char:match("%s") ~= nil
    return is_match
end

function esc(text)
    return vim.api.nvim_replace_termcodes(text, true, false, true)
end

function attempt_completion(action)
    return function(fallback)
        if was_whitespace() then
            fallback()
            return
        end

        if not cmp.visible() then
            cmp.complete()
            return
        end

        action(function()
            print('skipping tab, no valid autocomplete')
        end)
    end
end

--
vim.opt.completeopt = {'menu', 'menuone', 'noselect', 'noinsert'}
cmp.setup({
    preselect = cmp.PreselectMode.None,
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    completion = {
        autocomplete = false,
    },
    mapping = {
        ['<tab>'] = attempt_completion(cmp.mapping.select_next_item()),
        ['<s-tab>'] = attempt_completion(cmp.mapping.select_prev_item()),
        ['<c-n>'] = attempt_completion(cmp.mapping.select_next_item()),
        ['<c-p>'] = attempt_completion(cmp.mapping.select_prev_item()),
        ['<esc>'] = function(fallback)
            if not cmp.visible() then
                fallback()
                return
            end

            cmp.abort()
        end,
        ['<cr>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        }),
    },
    sources = {
        { name = 'nvim_lsp_signature_help'},            -- from language server
        { name = 'nvim_lsp', keyword_length = 3 },      -- from language server
        { name = 'buffer', keyword_length = 2 },        -- source current buffer
        -- { name = 'vsnip', keyword_length = 2 },         -- nvim-cmp source for vim-vsnip
        -- { name = 'path' },                              -- file paths
        -- { name = 'calc'},                               -- source for math calculation
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    formatting = {
        fields = {'menu', 'abbr', 'kind'},
        format = function(entry, item)
            local menu_icon ={
                nvim_lsp = 'λ',
                vsnip = '⋗',
                buffer = 'Ω',
                path = '🖫',
            }
            item.menu = menu_icon[entry.source.name]
            return item
        end,
    },
})

-- Debug
function print_synstack()
    local curr_col = vim.fn.col('.')
    local curr_line = vim.fn.line('.')

    local stack = vim.fn.synstack(curr_line, curr_col)

    local stackstr = '(' .. curr_line .. ', ' .. curr_col .. '):' .. 'start<'
    for _, syn_id in ipairs(stack) do
        syn_name = vim.fn.synIDattr(syn_id, 'name')
        stackstr = stackstr .. syn_id .. ':' .. syn_name .. ','
    end
    stackstr = stackstr .. '>end'
    print(stackstr)
end
vim.keymap.set('n', '<leader>ss', print_synstack)
