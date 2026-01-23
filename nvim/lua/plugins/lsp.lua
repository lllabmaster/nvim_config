return {
  {
    "neovim/nvim-lspconfig",
    -- 1. 解决 nil 错误的核心：对 LSP 核心强制关闭延迟加载
    lazy = false, 
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- 2. 依次初始化插件，确保加载顺序
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "pyright", "bashls" },
        automatic_installation = true,
      })

      local lspconfig = require("lspconfig")
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- 3. 快捷键配置 (使用官方推荐的 LspAttach 方式)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local opts = { buffer = ev.buf, noremap = true, silent = true }
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<leader>fm', function() 
            vim.lsp.buf.format({ async = true }) 
          end, opts)
        end,
      })

      -- 4. 适配 0.11 的服务器配置逻辑
      -- 为了避免警告，我们不再使用 setup_handlers，而是手动枚举
      local servers = {
        pyright = {
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
        bashls = {},
      }

      -- 5. 统一启动服务器
      for server_name, server_opts in pairs(servers) do
        server_opts.capabilities = capabilities
        -- 注意：在 0.11 完全移除旧框架前，这样写是目前最稳妥的
        lspconfig[server_name].setup(server_opts)
      end
    end,
  },
}
