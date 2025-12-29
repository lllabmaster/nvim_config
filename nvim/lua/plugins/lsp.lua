-- ~/.config/nvim/lua/plugins/lsp-new.lua
return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "pyright", "clangd", "bashls", "lua_ls" }
    }
  },
  
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      automatic_installation = true,
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
      
      -- 获取补全能力
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      
      -- 通用 on_attach 函数
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, noremap = true, silent = true }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>fm', function() vim.lsp.buf.format({ async = true }) end, opts)
      end
      
      -- 手动配置每个 LSP 服务器（使用新 API）
      local servers = {
        {
          name = "pyright",
          cmd = { "pyright-langserver", "--stdio" },
          filetypes = { "python" },
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true
              }
            }
          }
        },
        {
          name = "clangd",
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu"
          },
          filetypes = { "c", "cpp", "objc", "objcpp" },
          root_dir = function(fname)
            return require('lspconfig.util').root_pattern(
              'compile_commands.json',
              'compile_flags.txt',
              '.git'
            )(fname) or vim.fn.getcwd()
          end
        },
        {
          name = "lua_ls",
          cmd = { "lua-language-server" },
          filetypes = { "lua" },
          settings = {
            Lua = {
              runtime = { version = 'LuaJIT' },
              diagnostics = { globals = { 'vim' } },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false }
            }
          }
        },
        {
          name = "bashls",
          cmd = { "bash-language-server", "start" },
          filetypes = { "sh", "bash" }
        }
      }
      
      -- 启动所有配置的服务器
      for _, config in ipairs(servers) do
        config.on_attach = on_attach
        config.capabilities = capabilities
        vim.lsp.start(config)
      end
    end
  }
}
