-- Telescope Setup -- --------------------------------------------------------

require("telescope").load_extension("file_browser")

-- Key Maps -- ---------------------------------------------------------------

local wk = require("which-key")

local function cmd(str) -- wrap with "<Cmd>..<Cr>"; avoid typos, better highlighting
  return '<Cmd>' .. str .. '<CR>'
end

-- convert {a="b", c="d"} -> "{a = b, c = d}" - no quotes on values, for keymaps
-- if args is nil/string, return as-is
local function argify(args)
  if args == nil or type(args) == "string" then
    return args
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

local function grep(args) -- def for live_grep
  local args_str = args and argify(args) or ""
  return cmd("lua require('telescope.builtin').live_grep(" .. args_str .. ")")
end

-- use several variant cwd=$path below, so just make a catalog of them
local paths = {
  cwd = 'vim.fn.getcwd()',
  file_parent_n = function(n) return 'require("benfleis").get_path_ancestor(nil, ' .. tostring(n) .. ')' end,
  file_repo = 'require("benfleis").get_repo_root()',
  home = '"~"',
  xdg_config = '"~/.config"',
  xdg_local = '"~/.local"',
  xdg_share = '"~/.share"',
  nvim_config = '"~/.config/nvim"',
}

-- DRY definitions for double taps which have multiple bindings
-- tried using <Leader>... redirects, but those fail, guessing load order?
local buffer_delete = cmd("Bclose")
local buffer_find = cmd("Telescope buffers")
local buffer_next = cmd("bn")
local buffer_prev = cmd("bp")
local grep_cwd = grep({ cwd = paths.cwd })
local ff_cwd = ff({ cwd = paths.cwd })
local ff_sibling = ff({ cwd = paths.file_parent_n(1) })
local manage_git = cmd("Git")

-- nnoremap <Leader>ep <cmd>lua require('telescope.builtin').find_files{cwd = require('benfleis').get_path_ancestor(nil, vim.api.nvim_eval('v:count1') + 1)}<CR>

-- holy scheisse my life is complete. swap arrow / ctrl-[np] in cmdline editing.
vim.api.nvim_set_keymap("c", "<Up>", "<C-p>", { noremap = true })
vim.api.nvim_set_keymap("c", "<Down>", "<C-n>", { noremap = true })
vim.api.nvim_set_keymap("c", "<C-p>", "<Up>", { noremap = true })
vim.api.nvim_set_keymap("c", "<C-n>", "<Down>", { noremap = true })
vim.api.nvim_set_keymap("", "<Leader>y", '"*y', { noremap = true })

function Keys (...)
  if ... == nil or #... == 0 then
    return ""
  end

  local tail = ""
  for _, v in ipairs {...} do
    tail = tail .. (v or "")
  end
  if string.len(tail) == 0 then
    assert(tail ~= "", "No [valid] args given to Keys")
  end
  return tail
end

function L (...) return "<Leader>" .. Keys(...) end
function LL (...) return "<Leader><Leader>" .. Keys(...) end


wk.add(
  {
    { L("b"), group = "buffer" },
    { L("bd"), "<Cmd>Bclose<CR>", desc = "[b]uffer [d]elete" },
    { L("bf"), "<Cmd>Telescope buffers<CR>", desc = "[b]uffer [f]ind" },
    { L("bn"), "<Cmd>bn<CR>", desc = "[b]uffer [n]ext" },
    { L("bp"), "<Cmd>bp<CR>", desc = "[b]uffer [p]revious" },
    { L("d"), group = "display" },
    { L("dw"), "<Cmd>setlocal wrap!<CR>", desc = "toggle [w]rap on/off" },
    { L("f"), group = "find" },
    { L("f2p"), "<Cmd>lua require('telescope.builtin').find_files({cwd = require(\"benfleis\").get_path_ancestor(nil, 3), })<CR>", desc = "[f]ind files CWD=[2p]arent" },
    { L("f3p"), "<Cmd>lua require('telescope.builtin').find_files({cwd = require(\"benfleis\").get_path_ancestor(nil, 4), })<CR>", desc = "[f]ind files CWD=[3p]arent" },
    { L("f4p"), "<Cmd>lua require('telescope.builtin').find_files({cwd = require(\"benfleis\").get_path_ancestor(nil, 5), })<CR>", desc = "[f]ind files CWD=[4p]arent" },
    { L("fC"), "<Cmd>lua require('telescope.builtin').find_files({cwd = \"~/.config\", })<CR>", desc = "[f]ind files CWD=XDG [C]onfig" },
    { L("fH"), "<Cmd>lua require('telescope.builtin').find_files({cwd = \"~\", })<CR>", desc = "[f]ind files CWD=$[H]OME" },
    { L("fL"), "<Cmd>lua require('telescope.builtin').find_files({cwd = \"~/.local\", })<CR>", desc = "[f]ind files CWD=XDG [L]ocal" },
    { L("fN"), "<Cmd>lua require('telescope.builtin').find_files({cwd = \"~/.config/nvim\", })<CR>", desc = "[f]ind files CWD=[N]eovim_config" },
    { L("fS"), "<Cmd>lua require('telescope.builtin').find_files({cwd = \"~/.share\", })<CR>", desc = "[f]ind files CWD=XDG [S]hare" },
    { L("fc"), "<Cmd>lua require('telescope.builtin').find_files({cwd = vim.fn.getcwd(), })<CR>", desc = "[f]ind files" },
    { L("fp"), "<Cmd>lua require('telescope.builtin').find_files({cwd = require(\"benfleis\").get_path_ancestor(nil, 2), })<CR>", desc = "[f]ind files CWD=[p]arent" },
    { L("fr"), "<Cmd>lua require('telescope.builtin').find_files({cwd = require(\"benfleis\").get_repo_root(), })<CR>", desc = "[f]ind files CWD=$(git [r]oot)" },
    { L("fs"), "<Cmd>lua require('telescope.builtin').find_files({cwd = require(\"benfleis\").get_path_ancestor(nil, 1), })<CR>", desc = "[f]ind files CWD=[s]ibling" },
    { L("g"), group = "go" },
    { L("j"), group = "jump" },
    { L("jn"), "<Cmd>lnext<CR>", desc = "[j]ump [n]ext location" },
    { L("jp"), "<Cmd>lprevious<CR>", desc = "[j]ump [p]revious location" },
    { L("m"), group = "manage" },
    { L("mf"), "<Cmd>Telescope file_browser<CR>", desc = "[m]anage [f]ile" },
    { L("mg"), "<Cmd>Git<CR>", desc = "[m]anage [g]it" },
    { L("mp"), "<Cmd>!gh pr browse<CR>", desc = "[m]anage github [p]r" },
    { L("s"), group = "search" },
    { L("s2p"), "<Cmd>lua require('telescope.builtin').live_grep({cwd = require(\"benfleis\").get_path_ancestor(nil, 3), })<CR>", desc = "[g]rep CWD=[2p]arent" },
    { L("s3p"), "<Cmd>lua require('telescope.builtin').live_grep({cwd = require(\"benfleis\").get_path_ancestor(nil, 4), })<CR>", desc = "[g]rep CWD=[3p]arent" },
    { L("s4p"), "<Cmd>lua require('telescope.builtin').live_grep({cwd = require(\"benfleis\").get_path_ancestor(nil, 5), })<CR>", desc = "[g]rep CWD=[4p]arent" },
    { L("sH"), "<Cmd>lua require('telescope.builtin').live_grep({cwd = \"~\", })<CR>", desc = "[g]rep CWD=$[H]OME" },
    { L("sN"), "<Cmd>lua require('telescope.builtin').live_grep({cwd = \"~/.config/nvim\", })<CR>", desc = "[g]rep CWD=[N]eovim_config" },
    { L("sc"), "<Cmd>lua require('telescope.builtin').live_grep({cwd = vim.fn.getcwd(), })<CR>", desc = "[g]rep" },
    { L("sp"), "<Cmd>lua require('telescope.builtin').live_grep({cwd = require(\"benfleis\").get_path_ancestor(nil, 2), })<CR>", desc = "[g]rep CWD=[p]arent" },
    { L("sr"), "<Cmd>lua require('telescope.builtin').live_grep({cwd = require(\"benfleis\").get_repo_root(), })<CR>", desc = "[g]rep CWD=$(git [r]oot)" },
    { L("ss"), "<Cmd>lua require('telescope.builtin').live_grep({cwd = require(\"benfleis\").get_path_ancestor(nil, 1), })<CR>", desc = "[g]rep CWD=[s]ibling" },
    { L("t"), group = "tab" },
    { L("tn"), "<Cmd>tabnext<CR>", desc = "[t]ab [n]ext" },
    { L("tp"), "<Cmd>tabprevious<CR>", desc = "[t]ab [p]revious" },
    { L("tw2"), "<Cmd>setlocal ts=2 sts=2 sw=2<CR>", desc = "[t]ab [w]idth = [2]" },
    { L("tw3"), "<Cmd>setlocal ts=3 sts=3 sw=3<CR>", desc = "[t]ab [w]idth = [3]" },
    { L("tw4"), "<Cmd>setlocal ts=4 sts=4 sw=4<CR>", desc = "[t]ab [w]idth = [4]" },
    { L("tw8"), "<Cmd>setlocal ts=8 sts=8 sw=8<CR>", desc = "[t]ab [w]idth = [8]" },
  },
  { mode = "n" }
)

-- double taps for the things I use all-the-time.
wk.add(
  {
    { LL(), group = "double-tap" },
    { LL("S"), "<Cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>", desc = "!! [S]ource luasnips" },
    { LL("b"), "<Cmd>Telescope buffers<CR>", desc = "!! find [b]uffer" },
    { LL("d"), "<Cmd>Bclose<CR>", desc = "!! [d]elete buffer" },
    { LL("f"), "<Cmd>lua require('telescope.builtin').find_files({cwd = require(\"benfleis\").get_path_ancestor(nil, 1), })<CR>", desc = "!! find [f]iles" },
    { LL("m"), "<Cmd>Git<CR>", desc = "!! manage [g]it" },
    { LL("n"), "<Cmd>bn<CR>", desc = "!! buffer [n]ext" },
    { LL("p"), "<Cmd>bp<CR>", desc = "!! buffer [p]revious" },
    { LL("s"), "<Cmd>lua require('telescope.builtin').live_grep({cwd = vim.fn.getcwd(), })<CR>", desc = "!! [s]earch files" },
  },
  { mode = "n" }
)

--  local ls = require('luasnip')
--  vim.keymap.set({ "i", "s" }, "C-k", function()
--    if ls.expand_or_jumpable() then
--      ls.expand_or_jump()
--    end
--  end, { silent = true })
-- 
--  local ls = require('luasnip')
--  vim.keymap.set({ "i", "s" }, "C-l", function()
--    if ls.choice_active() then
--      ls.change_choice(1)
--    end
--  end, { silent = true })

  -- customize completion for beancount mode, where all categories (Assets:Foo:Bar) get a cmp source
  local cmp = require("cmp")
  cmp.setup.filetype('beancount', {
    sources = cmp.config.sources({
      { name = 'buffer',
        option = {
          keyword_length = 2,
          keyword_pattern = [[\k\+]]
        }
      },
    }),
    mapping = cmp.mapping.preset.insert({
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    })
  })
