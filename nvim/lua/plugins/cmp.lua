-- ~/.config/nvim/lua/plugins/cmp.lua
return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" }
      },
    },
    config = function()
      -- 在 config 函数内部 require 所有模块
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      
      -- 加载友好代码片段
      require("luasnip.loaders.from_vscode").lazy_load()
      
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        -- 优化补全触发设置
        completion = {
          autocomplete = {
            cmp.TriggerEvent.TextChanged,
            cmp.TriggerEvent.InsertEnter,
          },
          keyword_length = 1, -- 输入1个字符就开始提示
          completeopt = "menu,menuone,noselect,preview",
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          
          -- 代码片段导航
          ['<C-j>'] = cmp.mapping(function()
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-k>'] = cmp.mapping(function()
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
          
          -- Tab 补全导航
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp', keyword_length = 1 },
          { name = 'luasnip', keyword_length = 1 },
          { 
            name = 'buffer', 
            keyword_length = 2,
            option = {
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end
            }
          },
          { name = 'path', keyword_length = 1 },
        }),
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            -- 添加图标
            local icons = {
               Text = "[T]",
               Method = "[M]",
               Function = "[F]",
               Constructor = "[C]",
               Field = "[F]",
               Variable = "[V]",
               Class = "[C]",
               Interface = "[I]",
               Module = "[M]",
               Property = "[P]",
               Unit = "[U]",
               Value = "[V]",
               Enum = "[E]",
               Keyword = "[K]",
               Snippet = "[S]",
               Color = "[C]",
               File = "[F]",
               Reference = "[R]",
               Folder = "[D]",  -- D for Directory
               EnumMember = "[E]",
               Constant = "[C]",
               Struct = "[S]",
               Event = "[E]",
               Operator = "[O]",
               TypeParameter = "[T]",
             }            
            vim_item.kind = string.format('%s', icons[vim_item.kind] or '?')
            
            -- 显示来源
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip = "[Snip]",
              buffer = "[Buf]",
              path = "[Path]",
            })[entry.source.name]
            
            return vim_item
          end
        }
      })
      
      -- 命令行补全设置
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })
      
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
    end
  }
}
