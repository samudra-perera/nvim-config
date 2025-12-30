return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")

    local sources = {
      -- 🔎 Diagnostics / Linters
      null_ls.builtins.diagnostics.eslint_d,
      null_ls.builtins.diagnostics.ruff,

      -- ✨ Formatters
      null_ls.builtins.formatting.prettier.with({
        filetypes = { "html", "json", "yaml", "markdown", "javascript", "typescript" },
      }),
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.shfmt.with({ extra_args = { "-i", "4" } }),
      null_ls.builtins.formatting.terraform_fmt,
      null_ls.builtins.formatting.ruff,   -- Ruff’s formatter
      null_ls.builtins.formatting.black,  -- Python Black
    }

    -- Autoformat on save
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    null_ls.setup({
      sources = sources,
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false })
            end,
          })
        end
      end,
    })
  end,
}

