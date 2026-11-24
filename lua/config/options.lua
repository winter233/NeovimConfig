-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.autoformat = false

local opt = vim.opt

opt.foldenable = false
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "globals" }
-- opt.smoothscroll = false
opt.fixendofline = false

vim.g.lazyvim_picker = "snacks"

-- using OSC52 clipboard in SSH connection
if vim.env.SSH_TTY then
  local function paste_from_internal_register()
    -- 关键：粘贴时从 Neovim 的内部寄存器（"）读取，完全不向终端发起查询
    return {
      vim.fn.split(vim.fn.getreg('"'), '\n'),
      vim.fn.getregtype('"'),
    }
  end

  local osc52 = require("vim.ui.clipboard.osc52")

  vim.g.clipboard = {
    -- 注意这里的 name 字段，对 which-key.nvim 的修复至关重要
    name = "OSC 52",
    copy = {
      ["+"] = osc52.copy("+"), -- 复制时，通过 OSC 52 写入 Windows 剪贴板
      ["*"] = osc52.copy("*"),
    },
    paste = {
      ["+"] = paste_from_internal_register, -- 粘贴时，安静地读取内部寄存器
      ["*"] = paste_from_internal_register,
    },
  }
end
