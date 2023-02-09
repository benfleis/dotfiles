return function(use)
  -- see after/plugin/defaults.lua for extends keymap install
  use({
    "folke/which-key.nvim",
      config = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
        require("which-key").setup({})
      end
  })

  -- can't live without Bclose!
  use({"rbgrouleff/bclose.vim"})

  -- experimental
  use({
    "nvim-telescope/telescope-file-browser.nvim",
    config = function()
      require("telescope").setup {
        extensions = {
          file_browser = {
            -- theme = "ivy",
            hijack_netrw = true,
            mappings = {
              i = {},
              n = {},
            }
          }
        }
      }
    end
  })

  -- look ma, no config necessary!
  local plugins = {
    "clojure-vim/clojure.vim",
    "tpope/vim-dispatch", -- required for vim-dispatch-neovim
    "radenling/vim-dispatch-neovim", -- required for vim-jack-in
    "clojure-vim/vim-jack-in", -- handy for conjure
    "Olical/conjure",
  }

  for _, plugin in ipairs(plugins) do
    use({ plugin })
  end
end

