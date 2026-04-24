return {
  -- Mason for managing LSPs, DAP, linters, and formatters.
  {
    'mason-org/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  },
  -- Bridge between Mason and lspconfig.
  {
    'mason-org/mason-lspconfig.nvim',
    config = function()
      require('mason-lspconfig').setup {
        ensure_installed = {
          'ansiblels',
          'pyright',
          'yamlls',
          'lua_ls',
          'bashls',
          'clangd',
        },
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    enabled = true,
    dependencies = {
      'saghen/blink.cmp',
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      local servers = { 'ansiblels', 'pyright', 'yamlls', 'lua_ls', 'bashls', 'clangd' }
      for _, lsp in ipairs(servers) do
        vim.lsp.enable(lsp)
        vim.lsp.config(lsp, {
          capabilities = capabilities,
        })
      end

      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            diagnostics = { disable = { 'missing-fields' } },
          },
        },
      })

      -- LSP Keymaps
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'LSP Hover' })
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'LSP Go to Definition' })
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'LSP Go to References' })
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'LSP Code Action' })

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          if client:supports_method('textDocument/formatting') then
            -- Format the current buffer on save
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
              end,
            })
          end
        end,
      })
    end,
  }
}
