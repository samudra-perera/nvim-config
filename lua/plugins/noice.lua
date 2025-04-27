return {
    'folke/noice.nvim',
    event = 'VeryLazy',     -- load lazily
    dependencies = {
        'MunifTanjim/nui.nvim', -- required UI framework
        'rcarriga/nvim-notify', -- (optional) for beautiful notifications
    },
    config = function()
        require('noice').setup {
            lsp = {
                override = {
                    ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                    ['vim.lsp.util.stylize_markdown'] = true,
                    ['cmp.entry.get_documentation'] = true,
                },
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = false,
                lsp_doc_border = false,
            },
            views = {
                cmdline_popup = {
                    border = { style = 'rounded' },
                    position = { row = '40%', col = '50%' },
                    size = { width = 60, height = 'auto' },
                    win_options = {
                        winblend = 20, -- ✨ transparency
                    },
                },
                popupmenu = {
                    win_options = {
                        winblend = 20,
                    },
                },
                mini = {
                    win_options = {
                        winblend = 20,
                    },
                },
            },
        }
    end,
}
