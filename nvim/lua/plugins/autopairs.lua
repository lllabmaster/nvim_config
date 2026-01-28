return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    local npairs = require("nvim-autopairs")

    npairs.setup({
      check_ts = true, -- 如果装了 treesitter，会更智能
      disable_filetype = { "TelescopePrompt", "vim" },
    })

    -- 如果你使用 nvim-cmp 自动补全，需要这段联动
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    cmp.event:on(
      "confirm_done",
      cmp_autopairs.on_confirm_done()
    )
  end,
}
