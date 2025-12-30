return {
  'EdenEast/nightfox.nvim',
  config = function()
    require('nightfox').setup {
      options = {
        transparent = false, -- 🔥 important for your WezTerm setup
        terminal_colors = true, -- enable if you want terminal to match too
      },
    }
    vim.cmd 'colorscheme carbonfox'
  end,
}
