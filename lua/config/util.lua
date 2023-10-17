local M = {}

function M.create_or_open_launch_json(root)
  local dir = root .. "/.vscode/"
  if not vim.loop.fs_stat(dir) then
    vim.loop.fs_mkdir(dir, 493)
  end
  local jfile = dir .. "launch.json"
  if not vim.loop.fs_stat(jfile) then
    local open_mode = vim.loop.constants.O_CREAT + vim.loop.constants.O_WRONLY + vim.loop.constants.O_TRUNC
    local fd = vim.loop.fs_open(jfile, "w", open_mode)
    if not fd then
      vim.notify("Could not create file " .. jfile)
      return
    end
    vim.loop.fs_chmod(jfile, 420)

    local conf = { type = "lldb" }

    local callback = function(debug_type)
      if not debug_type then
        return
      end
      if debug_type == "launch" then
        conf = {
          type = "lldb",
          request = "launch",
          name = "Debug",
          program = "PRGOGRAM",
          args = "[]",
          env = "[]",
          cwd = vim.cwd,
        }
      else
        conf = { type = "lldb", request = "attach", name = "Debug", env = "[]", cwd = vim.cwd }
      end
      local lua_conf = { version = "0.2.0", configurations = { conf } }
      vim.json.encode(lua_conf)
      local header = [[
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "type": "lldb",
            "name": "Debug",
]]
      local body = ""
      if debug_type == "launch" then
        body = [[
            "request": "launch",
            "program": "",
            "args": [],
            "env": [],
            "cwd": "${workspaceFolder}"
        }
    ]
}
]]
      else
        body = [[
            "request": "attach",
            "pid": "${command:pickProcess}"
        }
    ]
}
]]
      end
      local json = header .. body
      vim.loop.fs_write(fd, json)
      vim.loop.fs_close(fd)
      vim.cmd("e " .. jfile)
      if debug_type == "launch" then
        vim.api.nvim_win_set_cursor(0, { 11, 23 })
      end
    end
    callback = vim.schedule_wrap(callback)
    vim.ui.select({ "launch", "attach" }, { prompt = "Select debug type:" }, callback)

    -- update neo-tree
  else
    -- vim.schedule(function()
    vim.cmd("e " .. jfile)
    -- end)
  end
  -- open file
end

function M.paste_multi_lines()
  local content = vim.fn.getreg("+")
  local regtype = vim.fn.getregtype("+")
  local joined = table.concat(vim.split(content, "\n"), "")
  vim.fn.setreg("+", joined, regtype)
end

function M.split_to_args()
  local content = vim.fn.getreg("+")
  local regtype = vim.fn.getregtype("+")
  local joined = table.concat(vim.split(content, "\n"), "")
  joined = '"' .. table.concat(vim.split(joined, " "), '", "') .. '"'
  vim.fn.setreg("+", joined, regtype)
end

M.root_patterns = { ".git", "lua" }
-- returns the root directory based on:
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string?
  path = path and vim.fs.dirname(path) or vim.loop.cwd()
  ---@type string?
  local root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
  root = root and vim.fs.dirname(root) or vim.loop.cwd()
  ---@cast root string
  return root
end

return M
