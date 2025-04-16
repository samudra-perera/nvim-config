return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "williamboman/mason.nvim", config = true },
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    { "j-hui/fidget.nvim", opts = {} },
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    -- Set LSP keymaps when attached
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or "n"
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        map("K", vim.lsp.buf.hover, "Hover Docs")
        map("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
        map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
        map("<leader>lf", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_group = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_group,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_group,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
            callback = function(ev)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = highlight_group, buffer = ev.buf })
            end,
          })
        end
      end,
    })

    -- Extend capabilities with cmp
    local capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      require("cmp_nvim_lsp").default_capabilities()
    )

    -- lspconfig names (used for actual server setup)
    local servers = {
      basedpyright = {},
      tsserver = {},
      gopls = {},
      html = {},
      cssls = {},
      tailwindcss = {},
      dockerls = {},
      sqlls = {},
      terraformls = {},
      jsonls = {},
      yamlls = {},
      clangd = {},
    }

    -- Mason package names (used to ensure correct tools are installed)
    local mason_ensure_installed = {
      "basedpyright",
      "typescript-language-server",
      "gopls",
      "html-lsp",
      "css-lsp",
      "tailwindcss-language-server",
      "dockerfile-language-server",
      "sqls",
      "terraform-ls",
      "json-lsp",
      "yaml-language-server",
      "clangd",
      "stylua", -- formatter
    }

    require("mason").setup()

    require("mason-tool-installer").setup({
      ensure_installed = mason_ensure_installed,
    })

    require("mason-lspconfig").setup({
      handlers = {
        function(server_name)
          local config = servers[server_name] or {}
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
            on_attach = function(...) end, -- already handled via LspAttach autocommand
            settings = config.settings,
          })
        end,
      },
    })
  end,
}

