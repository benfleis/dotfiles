return function(use)
  use({
    "folke/which-key.nvim",
      config = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
        require("which-key").setup({})
      end
  })
  use({"rbgrouleff/bclose.vim"})
end

