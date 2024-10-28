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

  use({
    "Olical/conjure",
    requires = {
      {"tpope/vim-dispatch", opt = false},
      {"radenling/vim-dispatch-neovim", opt = false},
      {"clojure-vim/vim-jack-in", opt = false}}})

  -- look ma, no config necessary!
  local plugins = {
    "clojure-vim/clojure.vim",
    "nathangrigg/vim-beancount",
    "hrsh7th/cmp-buffer",
    "nvim-treesitter/playground",
    "tpope/vim-surround",
    "guns/vim-sexp",
    "tpope/vim-sexp-mappings-for-regular-people",
    "tpope/vim-repeat",
  }

  for _, plugin in ipairs(plugins) do use({ plugin }) end
end
