return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local fzf = require("fzf-lua")

    -- Setup fzf-lua
    fzf.setup({
      winopts = {
        height = 0.85,
        width = 0.85,
        preview = {
          layout = "vertical",
          vertical = "up:60%",
        },
      },
      files = {
        prompt = "Files❯ ",
        git_icons = true,
      },
      grep = {
        prompt = "Grep❯ ",
      },
    })

    -- LazyVim-style keymaps using fzf-lua
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }

    map("n", "<leader><leader>", fzf.files, { desc = "Find Files (fzf)", unpack(opts) })
    map("n", "<leader>/", fzf.live_grep, { desc = "Grep (fzf)", unpack(opts) })
    map("n", "<leader>fb", fzf.buffers, { desc = "Buffers (fzf)", unpack(opts) })
    map("n", "<leader>fh", fzf.help_tags, { desc = "Help Tags (fzf)", unpack(opts) })
    map("n", "<leader>fc", fzf.commands, { desc = "Commands (fzf)", unpack(opts) })
    map("n", "<leader>fr", fzf.oldfiles, { desc = "Recent Files (fzf)", unpack(opts) })
    map("n", "<leader>fd", fzf.diagnostics_workspace, { desc = "Workspace Diagnostics (fzf)", unpack(opts) })
  end,
}

