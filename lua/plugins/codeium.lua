return {
  'Exafunction/windsurf.nvim',
  event = 'InsertEnter',
  config = function()
    require('windsurf').setup {}
  end,
}
