return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim',       opts = {} },
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    ----------------------------------------------------------------------
    -- Keymaps on LSP attach
    ----------------------------------------------------------------------
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map('K', vim.lsp.buf.hover, 'Hover Docs')
        map('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
        map('<leader>lf', function()
          vim.lsp.buf.format { async = true }
        end, 'Format buffer')

        -- Highlight symbol under cursor
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.supports_method 'textDocument/documentHighlight' then
          local group = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = group,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = group,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
            callback = function(ev)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = group, buffer = ev.buf }
            end,
          })
        end
      end,
    })

    ----------------------------------------------------------------------
    -- Capabilities for nvim-cmp
    ----------------------------------------------------------------------
    local capabilities = vim.tbl_deep_extend(
      'force',
      vim.lsp.protocol.make_client_capabilities(),
      require('cmp_nvim_lsp').default_capabilities()
    )

    ----------------------------------------------------------------------
    -- Define servers (custom settings if needed later)
    ----------------------------------------------------------------------
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

    ----------------------------------------------------------------------
    -- Mason setup
    ----------------------------------------------------------------------
    require('mason').setup()

    require('mason-tool-installer').setup {
      ensure_installed = {
        'basedpyright',
        'typescript-language-server',
        'gopls',
        'html-lsp',
        'css-lsp',
        'tailwindcss-language-server',
        'dockerfile-language-server',
        'sqls',
        'terraform-ls',
        'json-lsp',
        'yaml-language-server',
        'clangd',
        'stylua',
      },
    }

    require('mason-lspconfig').setup {
      automatic_installation = true,
      handlers = {
        function(server_name)
          local config = servers[server_name] or {}
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = function() end, -- handled by autocmd
            settings = config.settings,
          }
        end,
      },
    }

    ----------------------------------------------------------------------
    -- Auto format on save
    ----------------------------------------------------------------------
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
      callback = function(event)
        vim.lsp.buf.format({
          async = false,
          bufnr = event.buf,
        })
      end,
    })

    ----------------------------------------------------------------------
    -- Diagnostics toggle keymaps
    ----------------------------------------------------------------------
    local diagnostics_active = true
    vim.keymap.set('n', '<leader>td', function()
      diagnostics_active = not diagnostics_active
      if diagnostics_active then
        vim.diagnostic.config { virtual_text = true }
        vim.notify('Diagnostics enabled', vim.log.levels.INFO)
      else
        vim.diagnostic.hide()
        vim.notify('Diagnostics disabled', vim.log.levels.INFO)
      end
    end, { desc = 'Toggle Diagnostics' })

    vim.keymap.set('n', '<leader>te', function()
      vim.diagnostic.config {
        virtual_text = { severity = { min = vim.diagnostic.severity.ERROR } },
      }
      vim.notify('Showing only Errors', vim.log.levels.INFO)
    end, { desc = 'Show Only Errors' })

    vim.keymap.set('n', '<leader>tw', function()
      vim.diagnostic.config {
        virtual_text = { severity = { min = vim.diagnostic.severity.WARN } },
      }
      vim.notify('Showing Warnings and Errors', vim.log.levels.INFO)
    end, { desc = 'Show Warnings and Errors' })

    if package.loaded['which-key'] then
      require('which-key').register {
        ['<leader>t'] = { name = '+toggle' },
        ['<leader>td'] = 'Toggle all Diagnostics',
        ['<leader>te'] = 'Show Only Errors',
        ['<leader>tw'] = 'Show Warnings and Errors',
      }
    end
  end,
}
