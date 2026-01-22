-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins

return {
   -- simple list no conf needed
   -- "nvim-treesitter/playground",
   -- "nvim-treesitter/nvim-treesitter-context",
   -- "nvim-treesitter/nvim-treesitter-textobjects",
   "tpope/vim-fugitive",
   "tpope/vim-rhubarb",
   -- "tpope/vim-surround",
   -- "tpope/vim-unimpaired",
   "orjangj/neotest-ctest",

   -- {
   --    "folke/tokyonight.nvim",
   --    opts = {
   --       lazy = true,
   --       style = "night",
   --       on_colors = function(colors)
   --          colors.border = colors.blue0
   --       end,
   --    },
   -- },
   {
      "miikanissi/modus-themes.nvim",
      priority = 1000,
      opts = {
         style = "modus_vivendi", -- Always use modus_operandi regardless of `vim.o.background`
         variant = "tinted", -- Use variant
         styles = {
            functions = { italic = true }, -- Enable italics for functions
         },

         -- on_colors = function(colors)
         --    colors.error = colors.red_faint -- Change error color to the "faint" variant
         -- end,
         -- on_highlights = function(highlight, color)
         --    highlight.Boolean = { fg = color.green } -- Change Boolean highlight to use the green color
         -- end,
      },
   },
}
