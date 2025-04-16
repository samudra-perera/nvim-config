return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  ft = { 'markdown' },
  config = function()
    require('render-markdown').setup {
      -- You can customize styling here if desired
      headings = { '❶ ', '❷ ', '❸ ', '❹ ', '❺ ', '❻ ' },
      bullets = { '•', '◦', '▪', '▫' },
    }

    -- Optional: automatically render on entering markdown files
    vim.api.nvim_create_autocmd('BufEnter', {
      pattern = '*.md',
      callback = function()
        require('render-markdown').render()
      end,
    })
  end,
}
