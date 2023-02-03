-- all the custom keys
vim.g.mapleader = ';'

local wk = require("which-key")

local function cmd(str) -- wrap with "<Cmd>..<Cr>"; avoid typos, better highlighting
  return '<Cmd>' .. str .. '<CR>'
end

local function argify(args) -- convert {a="b", c="d"} -> "{a = b, c = d}" - no quotes on values
  if args ~= nil then
    return nil
  end

  local buf = {"{"}
  for k, v in pairs(args) do
    table.insert(buf, k .. " = " .. v .. ", ")
  end
  table.insert(buf, "}")
  return table.concat(buf)
end

local function ff(args) -- def for find_files
  local args_str = args and argify(args) or ""
  return cmd("lua require('telescope.builtin').find_files(" .. args_str .. ")")
end

local function grep(args) -- def for find_files
  local args_str = args and argify(args) or ""
  return cmd("lua require('telescope.builtin').live_grep(" .. args_str .. ")")
end

-- use several variant cwd=$path below, so just make a catalog of them
local paths = {
  cwd = 'vim.fn.getcwd()',
  file_sibling = 'require("benfleis").get_file_dir()',
  file_parent = 'require("benfleis").get_path_ancestor(nil, 1)',
  file_parent_n = function(n) return 'require("benfleis").get_path_ancestor(nil, ' .. tostring(n) .. ')' end,
  file_repo = 'require("benfleis").get_repo_root()',
  home = '"~"',
  nvim_config = '"~/.config/nvim"',
}

-- DRY definitions for double taps which have multiple bindings
-- tried using <Leader>... redirects, but those fail, guessing load order?
local buffer_delete = cmd("Bclose")
local buffer_find = cmd("Telescope buffers")
local buffer_next = cmd("bn")
local buffer_prev = cmd("bp")

-- nnoremap <Leader>ep <cmd>lua require('telescope.builtin').find_files{cwd = require('benfleis').get_path_ancestor(nil, vim.api.nvim_eval('v:count1') + 1)}<CR>

wk.register({
  ["<Leader>"] = {
    b = {
      name = "buffer",
      d = { buffer_delete, "[b]uffer [d]elete" },
      f = { buffer_find, "[b]uffer [f]ind" },
      n = { buffer_next, "[b]uffer [n]ext" },
      p = { buffer_prev, "[b]uffer [p]revious" },
    },

    d = {
      name = "display",
      w = { cmd("setlocal wrap!"), "toggle [w]rap on/off" },
      W = { cmd("call WrapStyleToggle()"), "toggle [W]rap style toggle" },
    },

    f = {
      name = "find",
      c = { ff({ cwd = paths.cwd }), "[f]ind files" },
      s = { ff({ cwd = paths.file_sibling }), "[f]ind files CWD=[s]ibling" },
      p = { ff({ cwd = paths.file_parent }), "[f]ind files CWD=[p]arent" },
      ["2p"] = { ff({ cwd = paths.file_parent_n(3) }), "[f]ind files CWD=[2p]arent" },
      ["3p"] = { ff({ cwd = paths.file_parent_n(4) }), "[f]ind files CWD=[3p]arent" },
      ["4p"] = { ff({ cwd = paths.file_parent_n(5) }), "[f]ind files CWD=[4p]arent" },
      r = { ff('{ ' .. paths.file_repo .. ' }'), "[f]ind files CWD=$(git [r]oot)" },
      H = { ff({ cwd = paths.nvim_config }), "[f]ind files CWD=$[H]OME" },
      N = { ff({ cwd = paths.nvim_config }), "[f]ind files CWD=[N]eovim_config" },
    },

    g = {
      name = "go",
      g = { cmd("Git"), "[g]o [g]it status" },
    },

    s = {
      name = "search",
      c = { grep({ cwd = paths.cwd }), "[g]rep" },
      s = { grep({ cwd = paths.file_sibling }), "[g]rep CWD=[s]ibling" },
      p = { grep({ cwd = paths.file_parent }), "[g]rep CWD=[p]arent" },
      ["2p"] = { grep({ cwd = paths.file_parent_n(3) }), "[g]rep CWD=[2p]arent" },
      ["3p"] = { grep({ cwd = paths.file_parent_n(4) }), "[g]rep CWD=[3p]arent" },
      ["4p"] = { grep({ cwd = paths.file_parent_n(5) }), "[g]rep CWD=[4p]arent" },
      r = { grep({ cwd = paths.file_repo }), "[g]rep CWD=$(git [r]oot)" },
      H = { grep({ cwd = paths.nvim_config }), "[g]rep CWD=$[H]OME" },
      N = { grep({ cwd = paths.nvim_config }), "[g]rep CWD=[N]eovim_config" },
    },

    t = {
      name = "tab",
      ["w2"] = { cmd("setlocal ts=2 sts=2 sw=2"), "[t]ab [w]idth = [2]" },
      ["w3"] = { cmd("setlocal ts=3 sts=3 sw=3"), "[t]ab [w]idth = [3]" },
      ["w4"] = { cmd("setlocal ts=4 sts=4 sw=4"), "[t]ab [w]idth = [4]" },
      ["w8"] = { cmd("setlocal ts=8 sts=8 sw=8"), "[t]ab [w]idth = [8]" },

      n = { cmd("tn"), "[t]ab [n]ext" },
      p = { cmd("tp"), "[t]ab [p]revious" },
    },

    y = { '"*y', "[y]ank to system pasteboard" },
  },
})

wk.register({
  ["<Leader><Leader>"] = {
    name = "double-tap",
    -- buffer
    b = { buffer_find, "!! find [b]uffer" },
    d = { buffer_delete, "!! [d]elete buffer" },
    n = { buffer_next, "!! buffer [n]ext" },
    p = { buffer_prev, "!! buffer [p]revious" },

    -- find
    f = { ff(), "!! [f]ind files" }
      -- "<Cmd>lua require('telescope.builtin').find_files{ cwd = require('benfleis').get_file_dir()}<CR>
  },
})
