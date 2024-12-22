-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins

return {
  ----
  -- start by disabling things I don't want right now
  --
  -- stylua ignore start
  { "MagicDuck/grug-far", enabled = false },
  { "b0o/SchemaStore.nvim", enabled = false },
  { "folke/ts-comments.nvim", enabled = false },
  { "linux-cultist/venv-selector.nvim", enabled = false },
  --
  -- a couple are worth consideration after I stabillize / return to my base
  --
  { "MeanderingProgrammer/render-markdown.nvim", enabled = false },
  { "folke/flash.nvim", enabled = false },
  { "folke/persistence.nvim", enabled = false },
  { "iamcco/markdown-preview.nvim", enabled = false },
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },

  -- simple list no conf needed
  "nvim-neotest/neotest-plenary",
  "nvim-treesitter/playground",
  "nvim-treesitter/nvim-treesitter-context",
  "nvim-treesitter/nvim-treesitter-textobjects",
  "tpope/vim-fugitive",
  "tpope/vim-surround",
  "tpope/vim-unimpaired",

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

  {
    "mfussenegger/nvim-dap-python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "jay-babu/mason-nvim-dap.nvim",
    },
    -- stylua: ignore
    keys = {
      { "<LocalLeader>dt", function() require("dap-python").test_method() end, desc = "Debug Method", ft = "python" },
      { "<LocalLeader>dc", function() require("dap-python").test_class() end, desc = "Debug Class", ft = "python" },
    },
    config = function()
      require("dap-python").setup(LazyVim.get_pkg_path("debugpy", "/venv/bin/python"))
    end,
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          opts = {
            -- stylua: ignore
            -- is_test_file = function(_fp) vim.notify("is_test_file: " .. _fp); return true end,
            pytest_discover_instances = true,
          },
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "<LocalLeader>t", "", desc = "+test"},
      { "<LocalLeader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File (Neotest)" },
      { "<LocalLeader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All Test Files (Neotest)" },
      { "<LocalLeader>tr", function() require("neotest").run.run() end, desc = "Run Nearest (Neotest)" },
      { "<LocalLeader>tl", function() require("neotest").run.run_last() end, desc = "Run Last (Neotest)" },
      { "<LocalLeader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary (Neotest)" },
      { "<LocalLeader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output (Neotest)" },
      { "<LocalLeader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel (Neotest)" },
      { "<LocalLeader>tS", function() require("neotest").run.stop() end, desc = "Stop (Neotest)" },
      { "<LocalLeader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Toggle Watch (Neotest)" },
    },
    --keys = {
    --	{ "<LocalLeader>rt", require("neotest").run.run },
    --	{
    --		"<LocalLeader>rf",
    --		function()
    --			require("neotest").run.run(vim.fn.expand("%"))
    --		end,
    --	},
    --	-- debug: require("neotest").run.run({strategy = "dap"})
    --	-- stop: require("neotest").run.stop()
    --	-- attach: require("neotest").run.attach()
    --},
  },

  {
    "Vigemus/iron.nvim",
    cmd = {
      "IronRepl",
      "IronReplHere",
      "IronRestart",
      "IronSend",
      "IronFocus",
      "IronHide",
      "IronWatch",
      "IronAttach",
    },
    keys = {
      "<LocalLeader>ii",
      "<LocalLeader>ii",
      "<LocalLeader>sf",
      "<LocalLeader>sl",
      "<LocalLeader>su",
      "<LocalLeader>sm",
      "<LocalLeader>mc",
      "<LocalLeader>mc",
      "<LocalLeader>md",
      "<LocalLeader>s<cr>",
      "<LocalLeader>s<space>",
      "<LocalLeader>sq",
      "<LocalLeader>cl",

      { "<LocalLeader>rs", "<cmd>IronRepl<cr>" },
      { "<LocalLeader>rr", "<cmd>IronRestart<cr>" },
      { "<LocalLeader>rf", "<cmd>IronFocus<cr>" },
      { "<LocalLeader>rh", "<cmd>IronHide<cr>" },
    },
    main = "iron.core", -- <== This informs lazy.nvim to use the entrypoint of `iron.core` to load the configuration.
    opts = {
      config = {
        -- Whether a repl should be discarded or not
        scratch_repl = true,
        -- Your repl definitions come here
        repl_definition = {
          sh = {
            -- Can be a table or a function that
            -- returns a table (see below)
            command = { "bash" },
          },
          python = {
            command = { "python3" }, -- or { "ipython", "--no-autoindent" }
            -- format = require("iron.fts.common").bracketed_paste_python,
          },
        },
        -- How the repl window will be displayed
        -- See below for more information
        -- repl_open_cmd = require('iron.view').bottom(40),
      },
      -- Iron doesn't set keymaps by default anymore.
      -- You can set them here or manually add keymaps to the functions in iron.core
      keymaps = {
        send_motion = "<LocalLeader>ii",
        visual_send = "<LocalLeader>ii",
        send_file = "<LocalLeader>sf",
        send_line = "<LocalLeader>sl",
        send_until_cursor = "<LocalLeader>su",
        send_mark = "<LocalLeader>sm",
        mark_motion = "<LocalLeader>mc",
        mark_visual = "<LocalLeader>mc",
        remove_mark = "<LocalLeader>md",
        cr = "<LocalLeader>s<cr>",
        interrupt = "<LocalLeader>s<Space>",
        exit = "<LocalLeader>sq",
        clear = "<LocalLeader>cl",
      },
      -- If the highlight is on, you can change how it looks
      -- For the available options, check nvim_set_hl
      highlight = { italic = true },
      ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
    },
  },
}
