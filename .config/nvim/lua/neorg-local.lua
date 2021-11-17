local neorg_local = {}

function neorg_local.setup_keybinds()
    -- This sets the leader for all Neorg keybinds. It is separate from the regular <Leader>,
    -- And allows you to shove every Neorg keybind under one "umbrella".
    local neorg_leader = "<Leader>" -- You may also want to set this to <Leader>o for "organization"

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
                        { "td", "core.norg.qol.todo_items.todo.task_done" },
                        { "tu", "core.norg.qol.todo_items.todo.task_undone" },
                        { "tp", "core.norg.qol.todo_items.todo.task_pending" },
                        { "t<Space>", "core.norg.qol.todo_items.todo.task_cycle" },

                        -- Keys for managing notes
                        -- { neorg_leader .. "nn", "core.norg.dirman.new.note" },

                        { "<CR>", "core.norg.esupports.goto_link" },
                        { "<C-s>", "core.integrations.telescope.find_linkable" },

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

return neorg_local
