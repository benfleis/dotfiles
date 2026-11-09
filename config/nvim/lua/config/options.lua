-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mapleader = ";"
-- vim.g.maplocalleader = "<Space>"
vim.g.maplocalleader = ","

-- System clipboard only on request (;y ;D ;p ;P in keymaps.lua). Plain y/d/x/p stay in vim's
-- registers. LazyVim defaults to unnamedplus; it re-applies this value on VeryLazy.
vim.opt.clipboard = ""

-- Over ssh/herdr there is no pbcopy: "+ goes through the terminal (OSC 52; ghostty and kitty).
-- On the Mac nvim keeps pbcopy/pbpaste.
if vim.fn.has("mac") == 0 and (vim.env.SSH_TTY or vim.env.SSH_CONNECTION or vim.env.HERDR_ENV) then
   vim.g.clipboard = "osc52"
end
