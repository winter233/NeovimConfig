-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local Util = require("lazyvim.util")

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

map("n", "<C-D>", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>qt", "<cmd>tabclose<cr>", { desc = "Quit current tab" })

-- TODO: A-j
-- map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
-- map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<C-h>", "<Left>", { desc = "Cusor move left" })
map("i", "<C-l>", "<Right>", { desc = "Cusor move right" })
map("i", "<C-j>", "<Down>", { desc = "Cusor move down" })
map("i", "<C-k>", "<Up>", { desc = "Cursor move up" })
map("i", "<A-b>", "<esc>bi", { desc = "Move back one word" })

map("n", "<leader>a", "^")
map("n", "<leader>z", "$")

-- copy/paste
-- map({"n", "v"}, "<leader>y", '"+y', { desc = "copy to system clipboard" })
-- map("n", "<leader>p", '"+p', { desc = "paste to system clipboard" })

map("n", "<leader>dA", function()
  require("config.util").create_or_open_launch_json(Util.get_root())
end, { desc = "Create/open launch.json(root dir)" })
map("n", "<leader>da", function()
  require("config.util").create_or_open_launch_json(vim.loop.cwd())
end, { desc = "Create/open launch.json(cwd)" })

local lazyterm = function() Util.float_term(nil, { border = "single", cwd = require("config.util").get_root() }) end
map("n", "<leader>ft", lazyterm, { desc = "Terminal (root dir)" })
map("n", "<leader>fT", function() Util.float_term(nil, { border = "single" }) end, { desc = "Terminal (cwd)" })
-- map("n", "<C-/>", lazyterm, { desc = "Terminal (root dir)" })
-- map("n", "<C-_>", lazyterm, { desc = "which_key_ignore" })
-- map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
-- map("t", "<C-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
map("n", "<C-Space>", lazyterm, { desc = "Terminal (root dir)" })
map("t", "<C-Space>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<ESC>", "<C-\\><C-n>")
map("t", "<C-B>", "<C-\\><C-n><C-B>")
map("t", "<C-v>", '<C-\\><C-N>:lua require("lazyvim.util").paste_multi_lines()<cr>"+pa<cr>', { desc = "paste as commands" })
map("i", "<C-v>", '<C-C>:lua require("lazyvim.util").split_to_args()<cr>"+pa<cr>', { desc = "Paste as args" })


-- diff
map("n", "<leader>df", "<cmd>windo diffthis<cr>", { desc = "window diff"})
map("n", "<leader>dq", "<cmd>windo diffoff<cr>", { desc = "diffoff"})

map("n", "<A-`>", "<cmd>tablast<cr>", { desc = "switch to lasttab"})
map("n", "<A-l>", "<cmd>tabnext<cr>", { desc = "switch to next tab"})
map("n", "<A-h>", "<cmd>tabprevious<cr>", { desc = "switch to prev tab"})
map("n", "<A-1>", "<cmd>1gt<cr>", { desc = "switch to tab 1"})
map("n", "<A-2>", "<cmd>2gt<cr>", { desc = "switch to tab 2"})
map("n", "<A-3>", "<cmd>3gt<cr>", { desc = "switch to tab 3"})
map("n", "<A-4>", "<cmd>4gt<cr>", { desc = "switch to tab 4"})
