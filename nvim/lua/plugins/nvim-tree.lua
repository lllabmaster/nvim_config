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
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
        },
      },
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
    })
  end
}

