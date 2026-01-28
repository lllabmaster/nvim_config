return {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("lspsaga").setup({
            use_default_keymaps = false, -- 必须为 false
            ui = {
                border = "rounded",
                devicon = true,
            },
            definition = {
                keys = {
                    edit = "<CR>",
                    quit = "q",
                },
            },
        })

        -- 关键：clear = true 会在重新加载时清理掉旧的 autocmd
        local saga_group = vim.api.nvim_create_augroup("SagaCustomConfig", { clear = true })

        vim.api.nvim_create_autocmd("LspAttach", {
            group = saga_group,
            callback = function(args)
                local opts = { buffer = args.buf, silent = true }
                local keymap = vim.keymap.set

                -- 这里的配置会覆盖任何之前对 gd 的绑定
                -- keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts)
                keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
                keymap("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)
                keymap("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
                keymap("n", "<leader>sl", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
            end,
        })
    end,
}
