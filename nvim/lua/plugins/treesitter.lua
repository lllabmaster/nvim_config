return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate", -- 关键：每次更新或安装时自动下载 parser
  config = function()
    -- 这里建议加一个保护性调用，防止报错直接中断启动
    local status, configs = pcall(require, "nvim-treesitter.configs")
    if not status then
        return
    end

    configs.setup({
      -- 确保安装你常用的语言
      ensure_installed = { "lua", "vim", "vimdoc", "javascript", "typescript", "python", "markdown", "markdown_inline" },
      highlight = {
        enable = true, -- 启用语法高亮
      },
      indent = {
        enable = true, -- 启用缩进
      },
    })
  end,
}
