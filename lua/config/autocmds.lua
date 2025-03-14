-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd({ 'VimLeave', "UIEnter", "VimResume", "VimSuspend" }, {
	group = vim.api.nvim_create_augroup('wezterm_colorschem', { clear = true }),
  callback=function ()
    io.stdout:write("\027]111;;\027\\")
  end
})

vim.api.nvim_create_autocmd('ColorScheme', {
	group = vim.api.nvim_create_augroup('wezterm_colorschem', { clear = true }),
  callback=function ()
    local bg=vim.api.nvim_get_hl(0,{name='Normal',link=false}).bg
    io.stdout:write(("\027]11;#%06x\027\\"):format(bg))
  end
})

-- it seems neovim has bug in detect llvm filetype
-- set llvm filetype detection
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lifelines" },
	group = vim.api.nvim_create_augroup('check_filetype', { clear = true }),
  callback = function(opts)
    local first_line = vim.filetype._getline(opts.buf, 1)
    if vim.filetype._matchregex(first_line, [[;\|\<source_filename\>\|\<target\>]]) then
      vim.bo.filetype = 'llvm'
    end
  end,
})
