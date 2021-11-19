-- get the directory containing "current file" (via vim.fn.expand('%'))
function get_file_dir()
    -- get expand('%:h') if buffer has filename, otherwise use $CWD
    local sibling = vim.fn.expand('%:h')
    if (sibling ~= nil and sibling ~= '') then
        return sibling
    end
    return vim.fn.getcwd()
end

local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

parser_configs.norg = {
    install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg",
        files = { "src/parser.c", "src/scanner.cc" },
        branch = "main"
    },
}

-- finish tree sitter config
require('nvim-treesitter.configs').setup {
    ensure_installed = { "python", "norg" },
    playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
        },
    }
}

local neorg_local = require('neorg-local')

require('neorg').setup {
    -- Tell Neorg what modules to load
    load = {
        ["core.defaults"] = {}, -- Load all the default modules
        ["core.norg.concealer"] = {}, -- Allows for use of icons
        ["core.norg.dirman"] = { -- Manage your directories with Neorg
            config = {
                workspaces = {
                    hiring = "~/Documents/hiring",
                    logs = "~/Documents/logs",
                }
            }
        },
        ["core.integrations.telescope"] = {},
    },

    hook = neorg_local.setup_keybinds,
}
