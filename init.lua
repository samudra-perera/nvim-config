-- Load core options and keymaps
-- v
require 'core.options'
require 'core.keymaps'

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        error('Error cloning lazy.nvim:\n' .. out)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Plugin setup
require('lazy').setup {
    require 'plugins.neotree',
    require 'plugins.bufferline',
    require 'plugins.lualine',
    require 'plugins.treesitter',
    require 'plugins.fzf',
    require 'plugins.lsp',
    require 'plugins.autocompletion',
    require 'plugins.autoformatting',
    require 'plugins.gitsigns',

    -- require 'plugins.colortheme'
}

-- Load additional config like colorscheme AFTER plugins
