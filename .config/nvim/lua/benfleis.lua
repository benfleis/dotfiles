local Path = require('plenary.path')
local Job = require('plenary.job')
local M = {}

-- get the directory containing "current file" (via vim.fn.expand('%'))
function M.get_file_dir()
    -- get expand('%:h') if buffer has filename, otherwise use $CWD
    local sibling = vim.fn.expand('%:h')
    if (sibling ~= nil and sibling ~= '') then
        return sibling
    end
    return vim.fn.getcwd()
end

-- get ancestor of given path; path==nil -> use vim.fn.expand('%:h') for
-- current buf's file; depth==nil -> depth=1
function M.get_path_ancestor(path, depth)
    local cur = Path:new(path or vim.fn.expand('%:p'))
    depth = depth or 1
    -- assert depth numeric && >= 0
    -- assert path string && not insane?
    for i = 1, depth do cur = cur:parent() end
    return tostring(cur)
end

function M.get_repo_root()
    local outputs = {}
    Job:new({
        command = 'git',
        args = { 'rev-parse', '--show-toplevel' },
        -- cwd = '/usr/bin',
        -- env = { ['a'] = 'b' },
        on_stdout = function(_, output)
            table.insert(outputs, output)
        end,
    }):sync()
    -- gather outputs and trim: see http://lua-users.org/wiki/StringTrim
    return table.concat(outputs, ""):match'^%s*(.*%S)' or ''
end

function M.init()
    -- local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

    -- parser_configs.norg = {
    --     install_info = {
    --         url = "https://github.com/nvim-neorg/tree-sitter-norg",
    --         files = { "src/parser.c", "src/scanner.cc" },
    --         branch = "main"
    --     },
    -- }

    -- parser_configs.norg_meta = {
    --     install_info = {
    --         url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
    --         files = { "src/parser.c" },
    --         branch = "main"
    --     },
    -- }

    -- parser_configs.norg_table = {
    --     install_info = {
    --         url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
    --         files = { "src/parser.c" },
    --         branch = "main"
    --     },
    -- }

    -- finish tree sitter config
----require('nvim-treesitter.configs').setup {
----    -- " "norg", "norg_meta", "norg_table", 
----    ensure_installed = { "haskell", "cpp", "c", "javascript", "markdown" },
----    highlight = {
----        enable = true,
----    },

----    playground = {
----        enable = true,
----        disable = {},
----        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
----        persist_queries = false, -- Whether the query persists across vim sessions
----        keybindings = {
----            toggle_query_editor = 'o',
----            toggle_hl_groups = 'i',
----            toggle_injected_languages = 't',
----            toggle_anonymous_nodes = 'a',
----            toggle_language_display = 'I',
----            focus_language = 'f',
----            unfocus_language = 'F',
----            update = 'R',
----            goto_node = '<cr>',
----            show_help = '?',
----        },
----    }
----}

    -- local neorg_local = require('neorg-local')
    -- use {
    --     "nvim-neorg/neorg",
    --     run = ":Neorg sync-parsers", -- This is the important bit!
    --     config = function()
    --         require("neorg").setup {
    --             -- configuration here
    --         }
    --     end,
    -- }


    --require('neorg').setup {
    --    -- Tell Neorg what modules to load
    --    load = {
    --        ["core.defaults"] = {}, -- Load all the default modules
    --        ["core.norg.concealer"] = {}, -- Allows for use of icons
    --        ["core.norg.dirman"] = { -- Manage your directories with Neorg
    --            config = {
    --                workspaces = {
    --                    hiring = "~/Documents/hiring",
    --                    logs = "~/Documents/logs",
    --                    notes = "~/Documents/notes",
    --                }
    --            }
    --        },
    --        ["core.integrations.telescope"] = {},
    --        ["core.norg.esupports.hop"] = {},
    --    },

--------logger = {
--------    -- Should print the output to neovim while running
--------    use_console = true,

--------    -- Should highlighting be used in console (using echohl)
--------    highlights = true,

--------    -- Should write to a file
--------    use_file = true,

--------    -- Any messages above this level will be logged.
--------    level = "warn",

--------    -- Level configuration
--------    modes = {
--------        { name = "trace", hl = "Comment", },
--------        { name = "debug", hl = "Comment", },
--------        { name = "info",  hl = "None", },
--------        { name = "warn",  hl = "WarningMsg", },
--------        { name = "error", hl = "ErrorMsg", },
--------        { name = "fatal", hl = "ErrorMsg", },
--------    },

--------    -- Can limit the number of decimals displayed for floats
--------    float_precision = 0.01,
--------},

        -- hook = M.setup_neorg_keybinds,
    --}

    -- https://github.com/lewis6991/gitsigns.nvim
----require('gitsigns').setup {
----    on_attach = function(bufnr)
----        local function map(mode, lhs, rhs, opts)
----            opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
----            vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
----        end

----        -- Navigation
----        map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
----        map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})

----        -- Actions
----        map('n', '<leader>hs', ':Gitsigns stage_hunk<CR>')
----        map('v', '<leader>hs', ':Gitsigns stage_hunk<CR>')
----        map('n', '<leader>hr', ':Gitsigns reset_hunk<CR>')
----        map('v', '<leader>hr', ':Gitsigns reset_hunk<CR>')
----        map('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>')
----        map('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>')
----        map('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>')
----        map('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>')
----        map('n', '<leader>hb', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
----        map('n', '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<CR>')
----        map('n', '<leader>hd', '<cmd>Gitsigns diffthis<CR>')
----        map('n', '<leader>hD', '<cmd>lua require"gitsigns".diffthis("~")<CR>')
----        map('n', '<leader>td', '<cmd>Gitsigns toggle_deleted<CR>')

----        -- Text object
----        map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
----        map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
----    end
----}
end

function M.setup_neorg_keybinds()
    -- This sets the leader for all Neorg keybinds. It is separate from the regular <Leader>,
    -- And allows you to shove every Neorg keybind under one "umbrella".
    local leader = "<LocalLeader>" -- You may also want to set this to <Leader>o for "organization"

    -- Require the user callbacks module, which allows us to tap into the core of Neorg
    local neorg_callbacks = require('neorg.callbacks')

    -- Listen for the enable_keybinds event, which signals a "ready" state meaning we can bind keys.
    -- This hook will be called several times, e.g. whenever the Neorg Mode changes or an event that
    -- needs to reevaluate all the bound keys is invoked
    neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
            -- Map all the below keybinds only when the "norg" mode is active
            keybinds.map_event_to_mode(
                "norg",
                {
                    n = { -- Bind keys in normal mode

                        -- Keys for managing TODO items and setting their states
                        { leader .. "md", "core.norg.qol.todo_items.todo.task_done" },
                        { leader .. "mu", "core.norg.qol.todo_items.todo.task_undone" },
                        { leader .. "mp", "core.norg.qol.todo_items.todo.task_pending" },
                        { leader .. "m<Space>", "core.norg.qol.todo_items.todo.task_cycle" },

                        -- Keys for managing notes
                        -- { neorg_leader .. "nn", "core.norg.dirman.new.note" },

                        -- { "<CR>", "core.norg.esupports.locate_link_target" },
                        { "<CR>", "core.norg.esupports.hop.hop-link" },
                        { "<M-CR>", "core.norg.esupports.hop.hop-link", "vsplit" },
                        { leader .. "ee", "core.integrations.telescope.find_linkable" },
                        { leader .. "ewl", "core.integrations.telescope.find_linkable{workspace='logs'}" },
                        { leader .. "ewn", "core.integrations.telescope.find_linkable{workspace='notes'}" },

                        { "<M-k>", "core.norg.manoeuvre.item_up" },
                        { "<M-j>", "core.norg.manoeuvre.item_down" },
                    },
                    i = {
                        { "<C-l>", "core.integrations.telescope.insert_link" },
                    },
                    v = {
                        { "<C-l>", "core.integrations.telescope.insert_link" },
                    },
                },
                { silent = true, noremap = true }
            )
        end
    )
end


function M.setup_metals()
    -------------------------------------------------------------------------------
    -- These are example settings to use with nvim-metals and the nvim built-in
    -- LSP. Be sure to thoroughly read the `:help nvim-metals` docs to get an
    -- idea of what everything does. Again, these are meant to serve as an example,
    -- if you just copy pasta them, then should work,  but hopefully after time
    -- goes on you'll cater them to your own liking especially since some of the stuff
    -- in here is just an example, not what you probably want your setup to be.
    --
    -- Unfamiliar with Lua and Neovim?
    --  - Check out https://github.com/nanotee/nvim-lua-guide
    --
    -- The below configuration also makes use of the following plugins besides
    -- nvim-metals, and therefore is a bit opinionated:
    --
    -- - https://github.com/hrsh7th/nvim-cmp
    --   - hrsh7th/cmp-nvim-lsp for lsp completion sources
    --   - hrsh7th/cmp-vsnip for snippet sources
    --   - hrsh7th/vim-vsnip for snippet sources
    --
    -- - https://github.com/wbthomason/packer.nvim for package management
    -- - https://github.com/mfussenegger/nvim-dap (for debugging)
    -------------------------------------------------------------------------------
    local api = vim.api
    local cmd = vim.cmd

    local function map(mode, lhs, rhs, opts)
        local options = { noremap = true }
        if opts then
            options = vim.tbl_extend("force", options, opts)
        end
        api.nvim_set_keymap(mode, lhs, rhs, options)
    end

    ----------------------------------
    -- PLUGINS -----------------------
    ----------------------------------
  --cmd([[packadd packer.nvim]])
  --require("packer").startup(function(use)
  --    use({ "wbthomason/packer.nvim", opt = true })

  --    use({
  --        "hrsh7th/nvim-cmp",
  --        requires = {
  --            { "hrsh7th/cmp-nvim-lsp" },
  --            { "hrsh7th/cmp-vsnip" },
  --            { "hrsh7th/vim-vsnip" },
  --        },
  --    })
  --    use({
  --        "scalameta/nvim-metals",
  --        requires = {
  --            "nvim-lua/plenary.nvim",
  --            "mfussenegger/nvim-dap",
  --        },
  --    })
  --end)

    ----------------------------------
    -- OPTIONS -----------------------
    ----------------------------------
    -- global
    vim.opt_global.completeopt = { "menuone", "noinsert", "noselect" }
    -- vim.opt_global.shortmess:remove("F"):append("c")

    -- LSP mappings
    map("n", "gD", "<cmd>lua vim.lsp.buf.definition()<CR>")
    map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
    map("n", "<C-]>", "<cmd>lua vim.lsp.buf.implementation()<CR>")
    map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
    map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
    map("n", "gds", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
    map("n", "gws", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>")
    map("n", "<leader>cl", [[<cmd>lua vim.lsp.codelens.run()<CR>]])
    map("n", "<leader>sh", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]])
    map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
    map("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>")
    map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
    map("n", "<leader>ws", '<cmd>lua require"metals".hover_worksheet()<CR>')
    map("n", "<leader>aa", [[<cmd>lua vim.diagnostic.setqflist()<CR>]]) -- all workspace diagnostics
    map("n", "<leader>ae", [[<cmd>lua vim.diagnostic.setqflist({severity = "E"})<CR>]]) -- all workspace errors
    map("n", "<leader>aw", [[<cmd>lua vim.diagnostic.setqflist({severity = "W"})<CR>]]) -- all workspace warnings
    map("n", "<leader>d", "<cmd>lua vim.diagnostic.setloclist()<CR>") -- buffer diagnostics only
    map("n", "[c", "<cmd>lua vim.diagnostic.goto_prev { wrap = false }<CR>")
    map("n", "]c", "<cmd>lua vim.diagnostic.goto_next { wrap = false }<CR>")


    map("n", "<leader>mm", "<cmd>lua require('telescope').extensions.metals.commands()<CR>")



    -- Example mappings for usage with nvim-dap. If you don't use that, you can
    -- skip these
  --map("n", "<leader>dc", [[<cmd>lua require"dap".continue()<CR>]])
  --map("n", "<leader>dr", [[<cmd>lua require"dap".repl.toggle()<CR>]])
  --map("n", "<leader>dK", [[<cmd>lua require"dap.ui.widgets".hover()<CR>]])
  --map("n", "<leader>dt", [[<cmd>lua require"dap".toggle_breakpoint()<CR>]])
  --map("n", "<leader>dso", [[<cmd>lua require"dap".step_over()<CR>]])
  --map("n", "<leader>dsi", [[<cmd>lua require"dap".step_into()<CR>]])
  --map("n", "<leader>dl", [[<cmd>lua require"dap".run_last()<CR>]])

    -- completion related settings
    -- This is similiar to what I use
    local cmp = require("cmp")
    cmp.setup({
        sources = {
            { name = "nvim_lsp" },
            { name = "vsnip" },
        },
        snippet = {
            expand = function(args)
                -- Comes from vsnip
                vim.fn["vsnip#anonymous"](args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert({
            -- None of this made sense to me when first looking into this since there
            -- is no vim docs, but you can't have select = true here _unless_ you are
            -- also using the snippet stuff. So keep in mind that if you remove
            -- snippets you need to remove this select
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            -- I use tabs... some say you should stick to ins-completion but this is just here as an example
            ["<Tab>"] = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    fallback()
                end
            end,
            ["<S-Tab>"] = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                else
                    fallback()
                end
            end,
        }),
    })

    ----------------------------------
    -- LSP Setup ---------------------
    ----------------------------------
    local metals_config = require("metals").bare_config()

    -- Example of settings
    metals_config.settings = {
        showImplicitArguments = true,
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
    }

    -- *READ THIS*
    -- I *highly* recommend setting statusBarProvider to true, however if you do,
    -- you *have* to have a setting to display this in your statusline or else
    -- you'll not see any messages from metals. There is more info in the help
    -- docs about this
    -- metals_config.init_options.statusBarProvider = "on"

    -- Example if you are using cmp how to make sure the correct capabilities for snippets are set
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- metals_config.capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

    -- Debug settings if you're using nvim-dap
  --local dap = require("dap")

  --dap.configurations.scala = {
  --    {
  --        type = "scala",
  --        request = "launch",
  --        name = "RunOrTest",
  --        metals = {
  --            runType = "runOrTestFile",
  --            --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
  --        },
  --    },
  --    {
  --        type = "scala",
  --        request = "launch",
  --        name = "Test Target",
  --        metals = {
  --            runType = "testTarget",
  --        },
  --    },
  --}

    metals_config.on_attach = function(client, bufnr)
        -- require("metals").setup_dap()
    end

    -- Autocmd that will actually be in charging of starting the whole thing
    local nvim_metals_group = api.nvim_create_augroup("nvim-metals", { clear = true })
    api.nvim_create_autocmd("FileType", {
        -- NOTE: You may or may not want java included here. You will need it if you
        -- want basic Java support but it may also conflict if you are using
        -- something like nvim-jdtls which also works on a java filetype autocmd.
        pattern = { "scala", "sbt", "java" },
        callback = function()
            require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
    })
end


return M
