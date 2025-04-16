return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    ensure_installed = {
      'lua',
      'python',
      'typescript',
      'javascript',
      'go',
      'json',
      'bash',
      'html',
      'css',
      'markdown',
      'c',
      'cpp',
    },
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<CR>',
        node_incremental = '<CR>',
        node_decremental = '<BS>',
        scope_incremental = '<TAB>',
      },
    },
  },
  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)
  end,
}

