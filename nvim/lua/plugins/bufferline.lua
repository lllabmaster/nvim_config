return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  lazy = false,
  config = function()
    require("bufferline").setup({
      options = {
        always_show_bufferline = true,
      },
    })
    vim.keymap.set('n', '<S-l>', ':bnext<CR>')
    vim.keymap.set('n', '<S-h>', ':bprevious<CR>')
  end,
}
