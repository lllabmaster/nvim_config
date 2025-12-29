return {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeToggle", "NvimTreeFindFile" }, -- 关键：命令触发时自动加载插件
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
    { "<leader>f", "<cmd>NvimTreeFindFile<CR>", desc = "Find current file in tree" },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("nvim-tree").setup({
      view = {
        width = 30,
        side = "left",
      },
      renderer = {
        icons = {
          show = {
            file = false,
            folder = false,
            folder_arrow = false,
            git = true,
          },
        },
      },
      actions = {
        open_file = {
          quit_on_open = false,
          window_picker = {
             enable = false, -- 启用窗口选择器
          -- 关键：排除所有非nvim-tree窗口，强制创建新窗口
            exclude = {
              filetype = { "not_a_real_filetype" }, -- 清空排除列表
              buftype = {},
            },
          },
        },
      },
    })
  end
}

