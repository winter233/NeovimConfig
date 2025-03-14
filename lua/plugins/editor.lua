return {
  {
    "kkharji/sqlite.lua",
    lazy = true,
  },

  {
    "luisiacc/gruvbox-baby",
    lazy = true,
  },

  {
    "sainnhe/gruvbox-material",
  },

  {
    "Tsuzat/NeoSolarized.nvim",
  },
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox-baby",
    },
  },

  -- makes some plugins dot-repeatable like leap
  { "tpope/vim-repeat", event = "VeryLazy" },

  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        signature = { -- conflict lsp_signature
          enabled = false,
        },
      },
      presets = {
        bottom_search = false,
      },
    },
  },

  {
    "akinsho/bufferline.nvim",
    keys = {
      { "<leader>bs", "<Cmd>BufferLinePick<CR>", desc = "Select buffer" },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    keys = function()
      return {
        { "<cr>", desc = "Increment selection" },
        { "<bs>", desc = "Decrement selection", mode = "x" },
      }
    end,
    opts = {
      ensure_installed = {
        "cpp",
        "tablegen",
        "llvm",
        "bash",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<cr>",
          node_incremental = "<cr>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        mappings = {
          ["<space>"] = "none",
          ["<C-v>"] = "vsplit_and_quit_tree",
          ["O"] = "system_open",
          ["<C-o>"] = "open_and_quit_tree",
        },
      },
      commands = {
        vsplit_and_quit_tree = function(state)
          -- local node = state.tree:get_node()
          require("neo-tree.sources.filesystem.commands").open_vsplit(state)
          require("neo-tree.command").execute({ action = "close" })
        end,
        open_and_quit_tree = function(state)
          require("neo-tree.sources.filesystem.commands").open(state)
          require("neo-tree.command").execute({ action = "close" })
        end,
        system_open = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          vim.api.nvim_command(string.format("silent !xdg-open '%s'", path))
        end,
      },
    },
  },

  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        enabled = false,
      },
      picker = {
        layout = {
          cycle = true,
          preset = function()
            return vim.o.columns >= 120 and "dropdown" or "vertical"
          end,
        },
        win = {
          -- input window
          input = {
            keys = {
              ["<C-u>"] = "",
              ["<C-n>"] = { "history_forward", mode = { "i", "n" } },
              ["<C-p>"] = { "history_back", mode = { "i", "n" } },
              ["<C-h>"] = { "preview_scroll_left", mode = { "i", "n" } },
              ["<C-l>"] = { "preview_scroll_right", mode = { "i", "n" } },
              ["<C-/>"] = { "toggle_help_input", mode = { "i", "n" } },
              ["<A-y>"] = { "filter_type", mode = { "i", "n" } },
              ["<A-c>"] = { "filter_cur_file", mode = { "i", "n" } },
              ["<A-p>"] = { "filter_path", mode = { "i", "n" } },
              ["<A-b>"] = { "filter_whole_word", mode = { "i", "n" } },
              ["<A-d>"] = { "bufdelete", mode = { "i", "n" } },
            },
          },
        },
        actions = {
          ---@param picker snacks.Picker
          filter_type = function(picker)
            local sel = picker:current()
            if not sel then
              return
            end
            local ext = sel.file:match("^.+%.(.+)$")
            if not ext then
              return
            end
            picker.opts["exclude"] = picker.opts["exclude"] or {}
            table.insert(picker.opts["exclude"], "*." .. ext)
            picker.init_opts = picker.opts
            picker.list:set_target()
            picker:find()
          end,
          ---@param picker snacks.Picker
          filter_cur_file = function(picker)
            local sel = picker:current()
            if not sel then
              return
            end
            picker.opts["exclude"] = picker.opts["exclude"] or {}
            table.insert(picker.opts["exclude"], sel.file)
            picker.init_opts = picker.opts
            picker.list:set_target()
            picker:find()
          end,
          ---@param picker snacks.Picker
          filter_path = function(picker)
            vim.ui.input(
              { prompt = "Enter dir to exclude: " },
              function(input)
                picker.opts["exclude"] = picker.opts["exclude"] or {}
                table.insert(picker.opts["exclude"], input)
                picker.init_opts = picker.opts
                picker.list:set_target()
                picker:find()
              end)
          end,
          ---@param picker snacks.Picker
          filter_whole_word = function(picker)
            picker.opts["args"] = picker.opts["args"] or {}
            table.insert(picker.opts["args"], "-w")
            picker.init_opts = picker.opts
            picker.list:set_target()
            picker:find()
          end,
        },
      },
    },
    keys = {
      { "<A-o>", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<C-G>", LazyVim.pick("grep_word", { args = {"-w"} }), desc = "Grep whole word (Root Dir)" },
      { "<C-P>", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
    }
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "classic",
      win = {
        -- allow the popup to overlap with the cursor
        no_overlap = false,
      },
      spec = {
        {
          {"<leader>h", group = "hunk", icon = { cat = "filetype", name = "diff"}, },
          {"<leader>m", group = "highlights", icon = { icon = "󰸱", color = "cyan"}, },
        },
      },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")
        map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>hp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>hB", function() gs.blame() end, "Blame Buffer")
        map("n", "<leader>hd", gs.diffthis, "Diff This")
        map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },

  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "enter",
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Enable this to show formatters used in a notification
      -- Useful for debugging formatter issues
      format_notify = true,
      servers = {
        clangd = {
          mason = false,
          keys = {
            { "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
          },
          -- root_dir = nil,
          -- root_dir = function(fname)
          --   return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
          -- end,
        },
      },
    },
  },

  {
    "mfussenegger/nvim-dap",
    -- stylua: ignore
    keys = {
      { "<F5>",
        function()
          require("dap.ext.vscode").load_launchjs(nil, { lldb = { "c", "cpp" } })
          require("dap").continue()
        end,
        desc = "Start a C/Cpp debugging session",
      },
      { "<F17>", function() require'dap'.disconnect({terminateDebuggee = true}) end , desc = "Terminate debugging session"},
      { "<F10>", function() require("dap").step_over() end, desc = "Step Over", },
      { "<F11>", function() require("dap").step_into() end, desc = "Step Into", },
      { "<F12>", function() require("dap").step_out() end,  desc = "Step Out", },
      { "<F9>",  function() require'dap'.toggle_breakpoint() end, desc = "Toggle Breakpoint"},
      { "<F21>", function() require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Set a conditional breakpoint"},
    },
    config = function()
      local Config = require("lazyvim.config")
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(Config.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end

      -- cpp config
      local dap = require("dap")
      dap.set_log_level("DEBUG")
      dap.adapters.lldb = {
        type = "executable",
        command = "/usr/bin/lldb-vscode",
        name = "lldb",
      }
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    -- stylua: ignore
    keys = {
      {';', function() require('dapui').eval(vim.fn.expand('<cword>')) end, desc = "Evaluate cword"},
      {';', function() require("dapui").eval() end, mode = {'v'}, desc = "Evalue selected expr"},
    },
  },

  {
    "tiagovla/scope.nvim",
    lazy = false,
    config = true,
  },

  {
    "folke/todo-comments.nvim",
    -- stylua: ignore
    keys = {
      { "<leader>xf", "<cmd>execute 'TodoTrouble cwd='.expand('%:p')<cr>", desc = "Todo in current file" },
    },
  },

  {
    "winter233/neomark.nvim",
    config = true,
    keys = {
      { "<F7>",  "<leader>mn" , remap = true, mode = {"n", "v"} },
      { "<F19>", "<leader>mp", remap = true, mode = {"n", "v"} },
      { "<F8>",  "<leader>m]" , remap = true, mode = {"n", "v"} },
      { "<F20>", "<leader>m[", remap = true, mode = {"n", "v"} },
      { "<leader>mm", function() require("neomark").toggle() end, desc = "Mark/Unmark word under cursor"},
      { "<leader>mc", function() require("neomark").clear() end, desc = "Unmark all words"},
      { "<leader>mp", function() require("neomark").prev({ recursive = true }) end, desc = "prev marked word", mode = {"n", "v"} },
      { "<leader>mn", function() require("neomark").next({ recursive = true }) end, desc = "next marked word", mode = {"n", "v"} },
      { "<leader>m[", function() require("neomark").prev({ recursive = true, any = true }) end, desc = "prev any marked word", mode = {"n", "v"} },
      { "<leader>m]", function() require("neomark").next({ recursive = true, any = true }) end, desc = "next any marked word", mode = {"n", "v"} },
    },
  },

  {
    "alanfortlink/animatedbg.nvim",
    config = true,
    keys = {
      { "<leader>ux", function() require('animatedbg-nvim').play({ animation = "matrix" }) end, desc = "Matrix animation" },
    }
  },
}
