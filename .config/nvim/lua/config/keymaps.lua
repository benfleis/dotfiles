-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
--

local add = require("which-key").add
local keylib = require("keylib")

-- local short names
local paths = keylib.paths
local rhs = keylib.rhs
local cmd = rhs.cmd
local leader = rhs.leader
local leader_2x = rhs.leader_2x
local find = rhs.find
local find_from_parent = rhs.find_from_parent
local grep = rhs.grep
local grep_from_parent = rhs.grep_from_parent

local function map(mode, lhs, rhs_, opts)
   assert(opts.mode == nil)
   assert(opts.lhs == nil)
   assert(opts.rhs == nil)
   local spec = {}
   for k, v in ipairs(opts) do
      spec[k] = v
   end
   spec.mode = mode
   spec.lhs = lhs
   spec.rhs = rhs_
   add(spec)
end

-- stylua: ignore start
-- holy scheisse my life is complete. swap arrow / ctrl-[np] in cmdline editing.
map("c", "<Up>", "<C-p>", { noremap = true })
map("c", "<Down>", "<C-n>", { noremap = true })
map("c", "<C-p>", "<Up>", { noremap = true })
map("c", "<C-n>", "<Down>", { noremap = true })

-- ;y for yank to os clipboard
map("", leader("y"), '"*y', { noremap = true })

-- double Ctrl-[ to escape "insert" mode in Terminals
map("t", "<C-[><C-[>", "<C-\\><C-n>", { noremap = true })

map("n", leader("b"), "", { group = "buffer" })
map("n", leader("bd"), function() require("snacks").bufdelete() end, { desc = "[b]uffer [d]elete" })
map("n", leader("bf"), cmd("FzfLua buffers"), { desc = "[b]uffer [f]ind" })
map("n", leader("bn"), cmd("bn"), { desc = "[b]uffer [n]ext" })
map("n", leader("bp"), cmd("bp"), { desc = "[b]uffer [p]revious" })

map("n", leader("d"), "", { group = "display" })
map("n", leader("de"), vim.diagnostic.open_float, { desc = "[d]isplay [e]rror under cursor" })
map("n", leader("dw"), cmd("setlocal wrap!"), { desc = "toggle [d]isplay [w]rap" })



map("n", leader("f"), "", { group = "find" })
-- CWD is of the editor, not the current buffer!
map("n", leader("fc"), find({ cwd = rhs.cwd }), { desc = "[f]ind files in $[C]WD" })
-- find files relative to cur buffer
map("n", leader("fp"), find_from_parent(2), { desc = "[f]ind files cwd=[p]arent" })
map("n", leader("f2p"), find_from_parent(3), { desc = "[f]ind files in [2]nd [p]arent" })
map("n", leader("f3p"), find_from_parent(4), { desc = "[f]ind files in [3]rd [p]arent" })
map("n", leader("f4p"), find_from_parent(5), { desc = "[f]ind files in [4]th [p]arent" })

-- find file relative to specific fixed locs
map("n", leader("f~"), find({ cwd = paths.home }), { desc = "[f]ind files in $HOME" })
map("n", leader("fN"), find({ cwd = paths.nvim_config }), { desc = "[f]ind files in [N]eovim_config" })
map("n", leader("fC"), find({ cwd = paths.xdg_config }), { desc = "[f]ind files in XDG [C]onfig" })
map("n", leader("fL"), find({ cwd = paths.xdg_local }), { desc = "[f]ind files in XDG [L]ocal" })
map("n", leader("fS"), find({ cwd = paths.xdg_share }), { desc = "[f]ind files in XDG [S]hare" })
map("n", leader("fr"), find({ cwd = rhs.get_repo_root() }), { desc = "[f]ind files in $(git [R]oot)" })
map("n", leader("fb"), leader("bf"), { desc = "[f]ind [b]uffer"} )

map("n", leader("g"), "", { group = "grep" })
map("n", leader("gw"), grep({ cwd = paths.cwd }), { desc = "[g]rep (nvim) working dir" })
map("n", leader("gW"), cmd("FzfLua grep_cword"), { desc = "[g]rep current [w]ord" })
map("n", leader("gh"), grep({ cwd = paths.home }), { desc = "[g]rep in $[H]OME" })
map("n", leader("gN"), grep({ cwd = paths.nvim_config }), { desc = "[g]rep in [N]eovim_config" })
map("n", leader("gb"), "", { group = "grep" })
map("n", leader("gbp"), grep_from_parent(1), { desc = "[g]rep in [b]uf [p]arent" })
map("n", leader("gb2p"), grep_from_parent(2), { desc = "[g]rep in [b]uf [2]nd [p]arent" })
map("n", leader("gb3p"), grep_from_parent(3), { desc = "[g]rep in [b]uf [3]rd [p]arent" })
map("n", leader("gb4p"), grep_from_parent(4), { desc = "[g]rep in [b]uf [4]th [p]arent" })
map("n", leader("gbr"), grep({ cwd = rhs.get_repo_root() }), { desc = "[g]rep in [b]uf [r]epo" })

map("n", leader("j"), "", { group = "jump" })
map("n", leader("jn"), cmd("lnext"), { desc = "[j]ump [n]ext location" })
map("n", leader("jp"), cmd("lprevious"), { desc = "[j]ump [p]revious location" })

map("n", leader("m"), "", { group = "manage" })
-- map("n", leader("mf"), cmd("FzfLua file_browser"), { desc = "[m]anage [f]ile" })
map("n", leader("mg"), cmd("Git"), { desc = "[m]anage [g]it" })
map("n", leader("mp"), cmd("!gh pr browse"), { desc = "[m]anage github [p]r" })

map("n", leader("t"), "", { group = "tabs" }) -- yes, it's 2 different uses of the word. but it works
map("n", leader("tn"), cmd("tabnext"), { desc = "[t]ab [n]ext" })
map("n", leader("tp"), cmd("tabprevious"), { desc = "[t]ab [p]revious" })
map("n", leader("tw2"), cmd("setlocal ts=2 sts=2 sw=2"), { desc = "[t]ab [w]idth = [2]" })
map("n", leader("tw3"), cmd("setlocal ts=3 sts=3 sw=3"), { desc = "[t]ab [w]idth = [3]" })
map("n", leader("tw4"), cmd("setlocal ts=4 sts=4 sw=4"), { desc = "[t]ab [w]idth = [4]" })
map("n", leader("tw8"), cmd("setlocal ts=8 sts=8 sw=8"), { desc = "[t]ab [w]idth = [8]" })

-- double taps for the things I use all-the-time.
map("n", leader_2x(), "", { group = "!! double-tap" })
-- map("n", leader_2x("S"), cmd("source ~/.config/nvim/after/plugin/luasnip.lua"), { desc = "!! [S]ource luasnips" })
map("n", leader_2x("b"), leader("bf"), { desc = "find [b]uffer"} )
map("n", leader_2x("d"), leader("bd"), { desc = "!! [d]elete buffer" })
map("n", leader_2x("f"), find({ cwd = rhs.cwd }), { desc = "!! find [f]iles" })
map("n", leader_2x("g"), grep({ cwd = paths.cwd }), { desc = "!! [g]rep" })
map("n", leader_2x("m"), cmd("Git"), { desc = "!! manage [g]it" })
map("n", leader_2x("n"), cmd("bn"), { desc = "!! buffer [n]ext" })
map("n", leader_2x("p"), cmd("bp"), { desc = "!! buffer [p]revious" })
-- stylua: ignore start

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
--local cmp = require("cmp")
--cmp.setup.filetype("beancount", {
--  sources = cmp.config.sources({
--    {
--      name = "buffer",
--      option = {
--        keyword_length = 2,
--        keyword_pattern = [[\k\+]],
--      },
--    },
--  }),
--  mapping = cmp.mapping.preset.insert({
--    ["<C-Space>"] = cmp.mapping.complete(),
--    ["<C-e>"] = cmp.mapping.abort(),
--    ["<CR>"] = cmp.mapping.confirm({ select = true }),
--  }),
--})
