local Path = require('plenary.path')
local Job = require('plenary.job')
local M = {}

-- get the directory containing "current file" or $CWD if unspecified
function M.get_path_default()
    -- get expand('%:h') if buffer has filename, otherwise use $CWD
    local sibling = vim.fn.expand('%:h')
    if (sibling ~= nil and sibling ~= '') then
        return sibling
    end
    return vim.fn.getcwd()
end

-- get ancestor of given path;
-- - path==nil -> use vim.fn.expand('%:h') for path;
-- - depth==nil -> depth=1
-- - depth=0 -> return path untouched
-- - depth=1 -> returns parent path (typ. to find/search siblings), eg a/b/3 -> a/b
-- - depth=2 -> returns parent-parent path (to find parent subtree) eg a/b/3 -> a
-- - ...
-- not sure I love the name vs semantics, but didn't think up sth better within 60s!
function M.get_path_ancestor(path, depth)
    assert(depth == nil or depth >= 0, "invalid depth")
    if depth == 0 then
        return path
    end
    depth = depth or 1
    local cur = Path:new(path or vim.fn.expand('%:h'))
    if not cur or cur == nil then
        return vim.fn.getcwd()
    end
    for _ = 1, depth do
        cur = cur:parent()
    end
    return tostring(cur)
end

function M.get_repo_root()
    local outputs = {}
    Job:new({
        command = 'git',
        args = { 'rev-parse', '--show-toplevel' },
        -- cwd = '/usr/bin',
        -- env = { ['a'] = 'b' },
        on_stdout = function(_, output)
            table.insert(outputs, output)
        end,
    }):sync()
    -- gather outputs and trim: see http://lua-users.org/wiki/StringTrim
    return table.concat(outputs, ""):match'^%s*(.*%S)' or ''
end

function M.init()
end


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
    if config.relative ~= "" then  -- is_floating_window?
      vim.api.nvim_win_close(win, false)  -- do not force
      table.insert(closed_windows, win)
    end
  end
  print(string.format('Closed %d windows: %s', #closed_windows, vim.inspect(closed_windows)))
end

return M
