--------------------------------------------------
-- 基础设置
--------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"

--------------------------------------------------
-- 基础快捷键
--------------------------------------------------
-- 窗口切换
-- 窗口切换：Ctrl + hjkl
vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true })
vim.keymap.set("i", "<C-h>", "<Esc><C-w>h", { silent = true })
vim.keymap.set("i", "<C-j>", "<Esc><C-w>j", { silent = true })
vim.keymap.set("i", "<C-k>", "<Esc><C-w>k", { silent = true })
vim.keymap.set("i", "<C-l>", "<Esc><C-w>l", { silent = true })

--------------------------------------------------
-- 安装并加载 lazy.nvim
--------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

--------------------------------------------------
-- 关键：加载 lua/plugins 目录下所有插件配置
--------------------------------------------------
require("lazy").setup("plugins", {
  defaults = { lazy = true },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "zipPlugin",
      },
    },
  },
})

--------------------------------------------------
--  目录树
--------------------------------------------------
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })
vim.keymap.set("n", "<leader>f", ":NvimTreeFindFile<CR>", { silent = true })

--------------------------------------------------
-- LSP 相关快捷键
--------------------------------------------------
-- 这些快捷键在 lsp.lua 中已部分配置，这里添加一些全局快捷键

-- 快速重新加载 Neovim 配置
vim.keymap.set("n", "<leader><leader>r", function()
  vim.cmd("source ~/.config/nvim/init.lua")
  vim.notify("Neovim 配置已重新加载", vim.log.levels.INFO)
end, { desc = "重新加载配置" })

-- 打开 Mason 管理界面
vim.keymap.set("n", "<leader>lm", ":Mason<CR>", { desc = "打开 Mason (LSP 管理)" })

-- 显示 LSP 信息
vim.keymap.set("n", "<leader>li", ":LspInfo<CR>", { desc = "显示 LSP 信息" })

-- 重启 LSP 服务器
vim.keymap.set("n", "<leader>lr", ":LspRestart<CR>", { desc = "重启 LSP 服务器" })

-- vim.api.nvim_create_autocmd("VimEnter", {
--  callback = function()
--    require("nvim-tree.api").tree.open()
--  end
-- })


-- 我的快捷键
vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<CR>", { noremap = true, silent = true })

