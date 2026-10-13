local Path = require("plenary.path")
local Job = require("plenary.job")
local M = {
  rhs = {}, -- place functions used for keyspec RHS in here; many funcs return func
  paths = {}, -- paths relevant to keymaps
}

local rhs = M.rhs
M.rhs.cwd = vim.uv.cwd

-- possibly unnecessary now, was intended to allow hierarchical keymap decls; leave as is while moving to LazyVim
local function Keys(...)
  if ... == nil or #... == 0 then
    return ""
  end

  local tail = ""
  for _, v in ipairs({ ... }) do
    tail = tail .. (v or "")
  end
  if string.len(tail) == 0 then
    assert(tail ~= "", "No [valid] args given to Keys")
  end
  return tail
end

-- -- -- --
-- Do a little bit of wrapping to make defs below short.
-- Mostly this means deferred execution of cwd param.
--

local function resolve_cwd(args)
  -- eval time - resolve cwd generating thunk
  if args and args.cwd and type(args.cwd) == "function" then
    args.cwd = args.cwd()
  end
  return args
end

-- generate RHS find_files command
function M.rhs.find(args)
  return function()
    require("fzf-lua").files(resolve_cwd(args))
  end
end

function M.rhs.find_from_parent(n)
  return M.rhs.find({ cwd = rhs.get_path_ancestor(nil, n) })
end

-- generate RHS live_grep command
function M.rhs.grep(args)
  return function()
    require("fzf-lua").live_grep(resolve_cwd(args))
  end
end

function M.rhs.grep_from_parent(n)
  return M.rhs.grep({ cwd = rhs.get_path_ancestor(nil, n) })
end

-- -- -- --
-- many path related things, both constants and funcs
--
M.paths.home = Path:new("~")
M.paths.nvim_config = Path:new("~/.config/nvim")
M.paths.xdg_config = Path:new("~/.config")
M.paths.xdg_local = Path:new("~/.local")
M.paths.xdg_share = Path:new("~/.share")

-- -- -- --
-- A bunch of util functions specifically built for keymap support, meaning
-- they sometimes do things like returning strings with quotes, etc.
--

function M.quote(str)
  return '"' .. string.gsub(str, '"', '\\"') .. '"'
end

-- only quote Paths - if discover that other string literals need to be quoted, will have to add a pseudo type
function M.encode_rhs_value(v)
  return Path.is_path(v) and M.quote(tostring(v)) or tostring(v)
end

-- wrap with "<Cmd>..<Cr>"; avoid typos, better highlighting
function M.rhs.cmd(str)
  return "<Cmd>" .. str .. "<CR>"
end

function M.rhs.leader(...)
  return "<Leader>" .. Keys(...)
end

function M.rhs.leader_2x(...)
  return M.rhs.leader(M.rhs.leader(Keys(...)))
end

function M.rhs.loc_leader(...)
  return "<LocalLeader>" .. Keys(...)
end

function M.rhs.loc_leader_2x(...)
  return M.rhs.loc_leader(M.rhs.loc_leader(Keys(...)))
end

-- convert {a="b", c="d"} -> '{a="b", c="d"}' - quotes on str values, for keymaps
-- if args is not a table, return (and if string, quote)
function M.rhs.argify(args)
  if type(args) ~= "table" then
    return M.encode_rhs_value(args)
  end

  local buf = { "{" }

  -- first handle positionals, pop as we work
  for _ = 1, #args do
    table.insert(buf, tostring(M.encode_rhs_value(args[1])) .. ", ")
    table.remove(args, 1)
  end

  -- then k, v pairs
  for k, v in pairs(args) do
    local v_es = M.encode_rhs_value(v)
    if type(k) == "number" then -- cheap stand in for integer
      table.insert(buf, "[" .. k .. "]=" .. v_es .. ", ")
    elseif type(k) == "string" then
      table.insert(buf, k .. "=" .. v_es .. ", ")
    else
      assert(false, "argify only accepts numeric and string keys")
    end
  end

  table.insert(buf, "}")
  return table.concat(buf)
end

-- get ancestor of given path;
-- - path==nil -> use buffer for path via vim.fn.expand('%')
-- - depth==nil -> depth=1
-- - depth=0 -> return path untouched eg a/b/my.txt -> a/b/my.txt
-- - depth=1 -> returns parent path (typ. to find/search siblings), eg a/b/my.txt -> a/b
-- - depth=2 -> returns parent-parent path (to find parent subtree) eg a/b/my.txt -> a
--
function M.get_path_ancestor(path, depth)
  assert(depth == nil or depth >= 0, "invalid depth")
  if depth == 0 then
    return path
  end
  depth = depth or 1
  local cur = Path:new(path or vim.fn.expand("%"))
  if not cur or cur == nil then
    return vim.fn.getcwd()
  end
  for _ = 1, depth - 1 do
    cur = cur:parent()
  end
  return tostring(cur)
end

-- return string calling to get_path_ancestor with proper escaping
function M.rhs.get_path_ancestor(path, depth)
  -- stylua: ignore
  return function() return M.get_path_ancestor(path, depth) end
end

function M.get_repo_root()
  local outputs = {}
  Job:new({
    command = "git",
    args = { "rev-parse", "--show-toplevel" },
    -- cwd = '/usr/bin',
    -- env = { ['a'] = 'b' },
    on_stdout = function(_, output)
      table.insert(outputs, output)
    end,
  }):sync()
  -- gather outputs and trim: see http://lua-users.org/wiki/StringTrim
  return table.concat(outputs, ""):match("^%s*(.*%S)")
end

function M.rhs.get_repo_root()
  -- stylua: ignore
  return function() return M.get_repo_root() end
end

function M.init() end

-- mind reader -- just thinking of this idea and randomly stumbled across _exactly_ what I want
-- https://www.statox.fr/posts/2021/03/breaking_habits_floating_window/
-- now just need to convert to lua :D
--  function! BreakHabitsWindow() abort
--      " Define the size of the floating window
--      let width = 50
--      let height = 10

--      " Create the scratch buffer displayed in the floating window
--      let buf = nvim_create_buf(v:false, v:true)

--      " Get the current UI
--      let ui = nvim_list_uis()[0]

--      " Create the floating window
--      let opts = {'relative': 'editor',
--                  \ 'width': width,
--                  \ 'height': height,
--                  \ 'col': (ui.width/2) - (width/2),
--                  \ 'row': (ui.height/2) - (height/2),
--                  \ 'anchor': 'NW',
--                  \ 'style': 'minimal',
--                  \ }
--      let win = nvim_open_win(buf, 1, opts)
--  endfunction

-- close all floating windows
M.close_all_floating_windows = function()
  local closed_windows = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then -- is_floating_window?
      vim.api.nvim_win_close(win, false) -- do not force
      table.insert(closed_windows, win)
    end
  end
  print(string.format("Closed %d windows: %s", #closed_windows, vim.inspect(closed_windows)))
end

return M
