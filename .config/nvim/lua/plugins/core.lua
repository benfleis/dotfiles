return {
   {
      "LazyVim/LazyVim",
      opts = {
         colorscheme = "modus_vivendi", -- OVERRIDE
         -- colorscheme = function()
         --    require("modus-themes").setup({
         --       style = "modus_vivendi", -- Always use modus_operandi regardless of `vim.o.background`
         --       variant = "tinted", -- Use variant
         --       styles = {
         --          functions = { italic = true }, -- Enable italics for functions
         --       },
         --       on_colors = function(colors)
         --          colors.error = colors.red_faint -- Change error color to the "faint" variant
         --       end,
         --       on_highlights = function(highlight, color)
         --          highlight.Boolean = { fg = color.green } -- Change Boolean highlight to use the green color
         --       end,
         --    })
         -- end,
      },
   },
}
