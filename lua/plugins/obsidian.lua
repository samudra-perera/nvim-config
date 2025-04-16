return {
    'epwalsh/obsidian.nvim',
    version = '*',
    lazy = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    opts = {
        workspaces = {
            {
                name = 'lessons',
                path = '/Users/samudraperera/Library/CloudStorage/GoogleDrive-samudrapup@gmail.com/My Drive/Lessons',
            },
        },
        daily_notes = {
            folder = 'dailies',
            date_format = '%Y-%m-%d',
            alias_format = '%B %-d, %Y',
            template = nil,
        },
        completion = {
            nvim_cmp = true,
        },
        mappings = {
            ['gf'] = {
                action = function()
                    require('obsidian').util.gf_passthrough()
                end,
                opts = { noremap = false, expr = true, buffer = true },
            },
        },
    },
    config = function(_, opts)
        require('obsidian').setup(opts)

        local vault_path = '/Users/samudraperera/Library/CloudStorage/GoogleDrive-samudrapup@gmail.com/My Drive/Lessons'

        -- 📂 Open the vault using fzf-lua file picker
        vim.keymap.set('n', '<leader>ov', function()
            require('fzf-lua').files {
                cwd = vault_path,
                prompt = 'Obsidian Vault > ',
            }
        end, { desc = 'Open Obsidian Vault in Neovim' })

        -- 📝 Obsidian note commands
        vim.keymap.set('n', '<leader>on', '<cmd>ObsidianNew<CR>', { desc = 'New Obsidian note' })
        vim.keymap.set('n', '<leader>ot', '<cmd>ObsidianToday<CR>', { desc = 'Open today’s daily note' })

        -- 🔍 FZF search in vault (markdown only)
        vim.keymap.set('n', '<leader>os', function()
            require('fzf-lua').grep {
                search_dirs = { vault_path },
                rg_opts = "--column --line-number --no-heading --color=always -g '*.md' -e",
            }
        end, { desc = 'Search notes in vault (markdown only)' })

        vim.keymap.set('n', '<leader>of', function()
            require('fzf-lua').live_grep {
                search_dirs = { vault_path },
            }
        end, { desc = 'Live grep in vault' })
        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'markdown',
            callback = function()
                vim.wo.conceallevel = 2
                vim.wo.concealcursor = 'nc'
            end,
        })
    end,
}
