return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },

    keys = {
      { "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<CR>", desc = "Find Files" },
      { "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<CR>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<CR>",   desc = "Buffers" },
    },

    config = function()
      require("telescope").setup({})
    end,
  },
}

