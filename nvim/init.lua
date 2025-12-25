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

-- vim.api.nvim_create_autocmd("VimEnter", {
--  callback = function()
--    require("nvim-tree.api").tree.open()
--  end
-- })
