return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "pyright", "bashls" },
        automatic_installation = true,
      })

      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      --------------------------------------------------
      -- 1. 定义全局 Handler 拦截逻辑
      --------------------------------------------------
      -- 这里的目的是：如果跳转的目标就是当前位置，则不触发任何操作
      local function filter_definition_handler(err, result, ctx, config)
        if not result or vim.tbl_isempty(result) then
          return vim.lsp.handlers["textDocument/definition"](err, result, ctx, config)
        end

        local client = vim.lsp.get_client_by_id(ctx.client_id)
        local curr_win = vim.api.nvim_get_current_win()
        local cursor = vim.api.nvim_win_get_cursor(curr_win)
        local curr_buf_uri = vim.uri_from_bufnr(ctx.bufnr)

        -- 判定是否为“当前位置”的过滤函数
        local function is_current_pos(loc)
          local target_uri = loc.uri or loc.targetUri
          local target_range = loc.range or loc.targetSelectionRange
          if target_uri == curr_buf_uri then
            -- LSP 行号从 0 开始，Neovim 从 1 开始
            if target_range.start.line == (cursor[1] - 1) then
              return true
            end
          end
          return false
        end

        -- 过滤掉指向当前位置的结果
        local filtered_result = {}
        if vim.tbl_islist(result) then
          for _, loc in ipairs(result) do
            if not is_current_pos(loc) then
              table.insert(filtered_result, loc)
            end
          end
        else
          if not is_current_pos(result) then
            filtered_result = result
          end
        end

        -- 如果过滤后为空，说明就在定义处，直接报错提示即可，不弹出浮窗
        if vim.tbl_isempty(filtered_result) then
          -- vim.notify("已经在定义位置", vim.log.levels.INFO)
          return
        end

        return vim.lsp.handlers["textDocument/definition"](err, filtered_result, ctx, config)
      end

      --------------------------------------------------
      -- 2. 快捷键配置
      --------------------------------------------------
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(ev)
          local opts = { buffer = ev.buf, noremap = true, silent = true }
          -- 只保留基础功能，gd 和 K 交给 lspsaga.lua
          -- vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          local builtin = require('telescope.builtin')
local opts = { noremap = true, silent = true, buffer = bufnr }

-- 跳转到定义 (Go to Definition)
vim.keymap.set('n', 'gd', builtin.lsp_definitions, opts)

-- 跳转到引用 (Go to References)
vim.keymap.set('n', 'gr', builtin.lsp_references, opts)

-- 跳转到实现 (Go to Implementation)
vim.keymap.set('n', 'gi', builtin.lsp_implementations, opts)

-- 跳转到类型定义 (Go to Type Definition)
vim.keymap.set('n', 'gt', builtin.lsp_type_definitions, opts)
          -- vim.keymap.set("n", "gd", require('telescope.builtin').lsp_definitions, opts)
          --  vim.keymap.set("n", "gr", require('telescope.builtin').lsp_references, opts)
          vim.keymap.set("n", "<leader>fm", function()
            vim.lsp.buf.format({ async = true })
          end, opts)
        end,
      })

      --------------------------------------------------
      -- 3. 服务器配置
      --------------------------------------------------
      local servers = {
        pyright = {
          handlers = {
            ["textDocument/definition"] = filter_definition_handler,
          },
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        bashls = {
          handlers = {
            ["textDocument/definition"] = filter_definition_handler,
          },
        },
      }

      for server_name, server_opts in pairs(servers) do
        server_opts.capabilities = capabilities
        lspconfig[server_name].setup(server_opts)
      end
    end,
  },
}
