local Util = require("lazyvim.util")

return {

  -- colorscheme: gruvbox
  {
    "luisiacc/gruvbox-baby",
    lazy = true,
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
          ["ov"] = "vsplit_and_quit_tree",
          ["O"] = "system_open",
          ["oo"] = "open_and_quit_tree",
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
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<C-P>", Util.telescope("find_files", { find_command = { "fd", "-E", "*test*" } }), desc = "Find Files no tests" },
      { "<C-N>", Util.telescope("live_grep"), desc = "Find in Files (Grep)" },
      { "<C-G>", Util.telescope("grep_string", { word_match = "-w" }), desc = "Find word under cursor (root dir)" },
      { "<A-o>", "<cmd>Telescope resume<cr>", desc = "Resume" },
    },
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-N>"] = require("telescope.actions").cycle_history_next,
            ["<C-P>"] = require("telescope.actions").cycle_history_prev,
            ["<C-J>"] = require("telescope.actions").move_selection_next,
            ["<C-K>"] = require("telescope.actions").move_selection_previous,
            ["<A-s>"] = require("telescope.actions").delete_buffer,
            ["`"] = require("telescope.actions").select_tab,
          },
        },
      },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      defaults = {
        mode = { "n", "v" },
        ["<leader>h"] = { name = "+hunks" },
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
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>hd", gs.diffthis, "Diff This")
        map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },

  -- buffer remove
  {
    "echasnovski/mini.bufremove",
    -- stylua: ignore
    keys = {
      { "<A-s>", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer", remap = false },
    },
  },

  {
    "LinArcX/telescope-env.nvim",
    -- stylua: ignore
    keys = {
      { "<leader>se", function() require("telescope").extensions.env.env() end, desc = "Search environment variables", },
    },
    config = function()
      require("telescope").load_extension("env")
    end,
  },

  {
    "inkarkat/vim-mark",
    event = "VeryLazy",
    keys = {
      { "<F7>", "<Plug>MarkSearchCurrentNext" },
      { "<F19>", "<Plug>MarkSearchCurrentPrev" },
      { "<F8>", "<Plug>MarkSearchAnyNext" },
      { "<F20>", "<Plug>MarkSearchAnyPrev" },
    },
    init = function()
      vim.g.mwIgnoreCase = 0
    end,
    dependencies = {
      "inkarkat/vim-ingo-library",
    },
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-cmdline",
    },
    config = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()

      cmp.setup({
        completion = {
          completeopt = "menu,menuone,noselect,noinsert",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = function(_, item)
            local icons = require("lazyvim.config").icons.kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end,
        },
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        sorting = defaults.sorting,
      })

      -- Set configuration for specific filetype.
      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
        }, {
          { name = "buffer" },
        }),
      })

      local feedkeys = require("cmp.utils.feedkeys")
      local keymap = require("cmp.utils.keymap")
      local cmd_mapping = {
        ["<Tab>"] = {
          c = function()
            if cmp.visible() then
              cmp.select_next_item()
            else
              feedkeys.call(keymap.t("<C-z>"), "n")
            end
          end,
        },
        ["<S-Tab>"] = {
          c = function()
            if cmp.visible() then
              cmp.select_prev_item()
            else
              feedkeys.call(keymap.t("<C-z>"), "n")
            end
          end,
        },
        ["<C-e>"] = {
          c = cmp.mapping.close(),
        },
      }
      -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline("/", {
        mapping = cmd_mapping,
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmd_mapping,
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },

  {
    "stevearc/aerial.nvim",
    lazy = true,
    keys = {
      {
        "<leader>ct",
        function()
          require("telescope").extensions.aerial.aerial()
        end,
        desc = "aerial symbol telescope",
      },
      {
        "<leader>cT",
        function()
          require("aerial").toggle()
        end,
        desc = "aerial symbol",
      },
    },
    config = function()
      require("aerial").setup()
      require("telescope").load_extension("aerial")
    end,
  },

  {
    "ray-x/lsp_signature.nvim",
    config = true,
    lazy = true,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      autoformat = false,
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
    "gbprod/yanky.nvim",
    opts = function()
      local mapping = require("yanky.telescope.mapping")
      local mappings = mapping.get_defaults()
      mappings.i["<c-p>"] = nil
      -- mappings.i["<c-j>"] = require("telescope.actions").move_selection_next
      -- mappings.i["<c-k>"] = require("telescope.actions").move_selection_previous
      -- mappings.i["<c-h]"] = require("yanky.telescope.mapping").put("P")
      -- mappings.i["<c-s]"] = require("yanky.telescope.mapping").delete
      return {
        highlight = { timer = 200 },
        ring = { storage = jit.os:find("Windows") and "shada" or "sqlite" },
        picker = {
          telescope = {
            use_default_mappings = false,
            mappings = {
              default = mapping.put("p"),
              i = {
                ["<c-p>"] = nil,
                ["<c-j>"] = require("telescope.actions").move_selection_next,
                ["<c-k>"] = require("telescope.actions").move_selection_previous,
                ["<c-h]"] = require("yanky.telescope.mapping").put("P"),
                ["<c-s>"] = require("yanky.telescope.mapping").delete(),
              },
            },
          },
        },
      }
    end,
  },

  {
    "tiagovla/scope.nvim",
    lazy = false,
    config = true,
  },

  {
    "folke/persistence.nvim",
    opts = {  -- needs pr 24
      pre_save = function()
        vim.cmd([[ScopeSaveState]])
      end,
      post_load = function()
        vim.cmd([[ScopeLoadState]])
      end,
    }
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    enabled = false,
  },

  {
    "echasnovski/mini.comment",
    enabled = false,
  },

  {
    "b3nj5m1n/kommentary",
    lazy = true,
    keys = {
      { "<C-_>", "<Plug>kommentary_line_default", desc = "toggle commit" },
      { "<C-_>", "<Plug>kommentary_visual_default<C-c>", mode = "v", desc = "toggle commit" },
      { "gcc", "<Plug>kommentary_line_default", desc = "toggle commit" },
      { "gcc", "<Plug>kommentary_visual_default<C-c>", mode = "v", desc = "toggle commit" },
    },
    config = function()
      require("kommentary.config").configure_language("default", {
        prefer_single_line_comments = true,
      })
      vim.g.kommentary_create_default_mappings = false
    end,
  },

}
