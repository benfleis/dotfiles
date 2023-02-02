-- all the custom keys
vim.g.mapleader = ';'

local wk = require("which-key")

local function cmd(str) -- avoid typos, better highlighting
  return '<Cmd>' .. str .. '<CR>'
end

local function ff(args_str) -- better def for find_files
  args_str = args_str or ""
  return cmd("lua require('telescope.builtin').find_files(" .. args_str .. ")")
end

-- DRY definitions for double taps which have multiple bindings
-- tried using <Leader>... redirects, but those fail, guessing load order?
local buffer_find = cmd("Telescope buffers")
local buffer_next = cmd("bn")

-- nnoremap <Leader>ep <cmd>lua require('telescope.builtin').find_files{cwd = require('benfleis').get_path_ancestor(nil, vim.api.nvim_eval('v:count1') + 1)}<CR>

wk.register({
  ["<Leader>"] = {
    b = {
      name = "buffer",
      f = { buffer_find, "[b]uffer find" },
      n = { buffer_next, "[b]uffer [n]ext" },
      p = { cmd("bp"), "[b]uffer [p]revious" },
    },

    f = {
      name = "find",
      c = { ff(), "[f]ind files" },
      s = { ff('{ cwd = require("benfleis").get_file_dir() }'), "[f]ind files CWD=[s]ibling" },
      p = { ff('{ cwd = require("benfleis").get_path_ancestor(nil, vim.api.nvim_eval("v:count1") + 1) }'), "[f]ind files CWD=[p]arent" },
      ["2p"] = { ff('{ cwd = require("benfleis").get_path_ancestor(nil, 3) }'), "[f]ind files CWD=[2p]arent" },
      ["3p"] = { ff('{ cwd = require("benfleis").get_path_ancestor(nil, 4) }'), "[f]ind files CWD=[3p]arent" },
      ["4p"] = { ff('{ cwd = require("benfleis").get_path_ancestor(nil, 5) }'), "[f]ind files CWD=[4p]arent" },
      r = { ff('{ cwd = require("benfleis").get_repo_root() }'), "[f]ind files CWD=$(git [r]oot)" },
    },

    g = {
      name = "go",
      s = { cmd("Git"), "[g]o git status" },
    },

    t = {
      name = "tab",
      ["w2"] = { cmd("setlocal ts=2 sts=2 sw=2"), "[t]ab [w]idth = [2]" },
      ["w3"] = { cmd("setlocal ts=3 sts=3 sw=3"), "[t]ab [w]idth = [3]" },
      ["w4"] = { cmd("setlocal ts=4 sts=4 sw=4"), "[t]ab [w]idth = [4]" },
      ["w8"] = { cmd("setlocal ts=8 sts=8 sw=8"), "[t]ab [w]idth = [8]" },

      n = { cmd("tn"), "[tn]ext" },
      p = { cmd("tp"), "[tp]revious" },
    },

    d = {
      name = "display",
      w = { cmd("setlocal wrap!"), "toggle [w]rap on/off" },
      W = { cmd("call WrapStyleToggle()"), "toggle [W]rap style toggle" },
    },

    y = { '"*y', "[y]ank to system pasteboard" },
  },
})

wk.register({
  ["<Leader><Leader>"] = {
    name = "double-tap",
    -- buffer
    b = { buffer_find, "!! find [b]uffer" },
    n = { buffer_next, "!! buffer [n]ext" },
    p = { buffer_next, "!! buffer [p]revious" },

    -- find
    f = { ff(), "[f]ind files" }
      -- "<Cmd>lua require('telescope.builtin').find_files{ cwd = require('benfleis').get_file_dir()}<CR>
  },
})
