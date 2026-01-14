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

   {
      "folke/tokyonight.nvim",
      opts = {
         lazy = true,
         style = "night",
         on_colors = function(colors)
            colors.border = colors.blue0
         end,
      },
   },
}
