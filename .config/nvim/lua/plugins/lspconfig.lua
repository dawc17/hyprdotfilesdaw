return {
  {
    "williamboman/nvim-lsp-installer",
  },
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      local on_attach = function(client, bufnr)
        print("LSP Client attached: " .. client.name .. " to buffer " .. bufnr)

        vim.diagnostic.config({
          virtual_text = true, -- Enable inline diagnostics
          signs = true,        -- Keep icons in the gutter
          underline = true,    -- Underline errors
          update_in_insert = false, -- Optional: disable updates during typing
          severity_sort = true, -- Optional: show errors before warnings, etc.
        })

        -- <<< STEP 3 (Recommended): Define buffer-local keymaps >>>
        local opts = { buffer = bufnr, noremap = true, silent = true }
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        -- Add any other LSP-related keymaps here (e.g., rename, references)
        -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        -- vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        -- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        -- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        -- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)

      end -- End of on_attach function

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach, -- Add this line
        settings = {       -- Example settings for lua_ls
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach, -- Add this line
        settings = {},
        init_options = {
          host_info = "neovim",
        }
      })

      lspconfig.html.setup({
        capabilities = capabilities,
        on_attach = on_attach, -- Add this line
      })

      lspconfig.eslint.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- Add other servers here using the same pattern:
      -- lspconfig.pyright.setup({
      --   capabilities = capabilities,
      --   on_attach = on_attach,
      -- })
    end,                                                  -- End of config function
    dependencies = { "williamboman/mason-lspconfig.nvim" }, -- Make sure dependencies are correctly listed if needed by your plugin manager
  },
}
