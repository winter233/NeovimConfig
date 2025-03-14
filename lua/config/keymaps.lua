-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local Util = require("config.util")

local map = LazyVim.safe_keymap_set

map("n", "<C-D>", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>qt", "<cmd>tabclose<cr>", { desc = "Quit current tab" })

map("n", "<A-d>", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })

-- TODO: A-j
-- map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
-- map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<C-h>", "<Left>", { desc = "Cusor move left" })
map("i", "<C-l>", "<Right>", { desc = "Cusor move right" })
map("i", "<C-j>", "<Down>", { desc = "Cusor move down" })
map("i", "<C-k>", "<Up>", { desc = "Cursor move up" })
map("i", "<A-b>", "<C-o>b", { desc = "Move back one word" })
map("i", "<A-w>", "<C-o>w", { desc = "Move forward one word" })

map("n", "<C-Q>", "^")
map("n", "<C-E>", "$")

-- copy/paste
-- map({"n", "v"}, "<leader>y", '"+y', { desc = "copy to system clipboard" })
-- map("n", "<leader>p", '"+p', { desc = "paste to system clipboard" })

map("n", "<leader>dA", function() Util.create_or_open_launch_json(Util.root()) end, { desc = "Create/open launch.json(root dir)" })
map("n", "<leader>da", function() Util.create_or_open_launch_json(vim.loop.cwd()) end, { desc = "Create/open launch.json(cwd)" })
---
---@type integer
local last_term = 1
local function lazyterm(index, close)
  index = index or 1
  close = close or false
  if close then
    vim.cmd("close")
  end
  last_term = index
  Snacks.terminal(nil, { win = { position = "float", border = "single"} , cwd = Util.root(), env = {NVIM_TERM_INDEX = index} })
end

map({"n", "i"}, "<A-1>", function() lazyterm(1) end, { desc = "Terminal (root)" })
map({"n", "i"}, "<A-2>", function() lazyterm(2) end, { desc = "Terminal (root)" })
map({"n", "i"}, "<A-3>", function() lazyterm(3) end, { desc = "Terminal (root)" })
map("t", "<A-1>", function() lazyterm(1, true) end, { desc = "switch to term 1" })
map("t", "<A-2>", function() lazyterm(2, true) end, { desc = "switch to term 2" })
map("t", "<A-3>", function() lazyterm(3, true) end, { desc = "switch to term 3" })
map("n", "<C-Space>", function() lazyterm(last_term) end, { desc = "Terminal last" })
map("t", "<C-Space>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<ESC>", "<C-\\><C-n>")
map("t", "<C-B>", "<C-\\><C-n><C-B>")
map("t", "<C-v>", '<C-\\><C-N>:lua require("config.util").paste_multi_lines()<cr>"+pa<cr>', { desc = "paste as commands" })
map("i", "<C-v>", '<C-C>:lua require("config.util").split_to_args()<cr>"+pa<cr>', { desc = "Paste as args" })


-- diff
map("n", "<leader>df", "<cmd>windo diffthis<cr>", { desc = "window diff"})
map("n", "<leader>dq", "<cmd>windo diffoff<cr>", { desc = "diffoff"})

map("n", "<A-`>", "<cmd>tablast<cr>", { desc = "switch to lasttab"})
map("n", "<A-l>", "<cmd>tabnext<cr>", { desc = "switch to next tab"})
map("n", "<A-h>", "<cmd>tabprevious<cr>", { desc = "switch to prev tab"})
