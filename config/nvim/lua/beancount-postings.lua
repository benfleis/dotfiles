-- Custom nvim-cmp source for beancount accounts.

local M = {}
local trigger = ':'
local ws_trigger = ' :'

local accounts = {
    "Assets:Ben:Cash",
    "Assets:Family:Cash",
    "Assets:Ben:NL:ABNAMRO:Payment",
    "Assets:Ben:NL:ASN:Payment",
    "Income:Ben:NL:ASN:Payment:Interest",
    "Assets:Ben:NL:Bunq:Payment",
    "Income:Ben:NL:Bunq:Payment:Interest",
    "Assets:Ben:DE:N26:Payment",
    "Assets:KaBe:NL:ASN:Payment",
    "Assets:KaBe:NL:ASN:Payment:Interest",
    "Assets:KaBe:NL:Bunq:Payment",
    "Assets:KaBe:NL:Bunq:Payment:Interest",
    "Expenses:Ben:Bike",
    "Expenses:Ben:Clothing",
    "Expenses:Ben:Entertain:In",
    "Expenses:Ben:Entertain:Out",
    "Expenses:Ben:Food:In",
    "Expenses:Ben:Food:Out",
    "Expenses:Ben:Household",
    "Expenses:Ben:Utility:Phone",
    "Expenses:Ben:Gifts",
    "Expenses:Family:Gifts",
    "Expenses:Family:Clothing",
    "Expenses:Family:Entertain:In",
    "Expenses:Family:Entertain:Out",
    "Expenses:Family:Food:In",
    "Expenses:Family:Food:Out",
    "Expenses:Family:Household",
    "Expenses:Family:Transportation:Car",
    "Expenses:Ben:Financial:Fees",
    "Expenses:KaBe:Financial:Fees",
    "Income:Ben:Untracked",
    "Income:Ben:Uber:Salary",
    "Expenses:Ben:Unknown",
    "Expenses:Family:Unknown",
}

local registered = false

M.setup = function()
  if registered then
    return
  end
  registered = true

  local has_cmp, cmp = pcall(require, 'cmp')
  if not has_cmp then
    return
  end

  local source = {}

  source.new = function()
    return setmetatable({}, {__index = source})
  end

  source.get_trigger_characters = function()
    return { trigger }
  end

  source.get_keyword_pattern = function()
    -- Add dot to existing keyword characters (\k).
    return [[\%(\k\|\.\)\+]]
  end

  source.complete = function(_, request, callback)
    local input = string.sub(request.context.cursor_before_line, request.offset - 1)
    local prefix = string.sub(request.context.cursor_before_line, 1, request.offset - 1)

    if vim.startswith(input, trigger) and (prefix == trigger or vim.endswith(prefix, ws_trigger)) then
      local items = {}
      for _, account in pairs(accounts) do
        table.insert(items, {
            filterText = account,
            label = account,
            textEdit = {
              newText = account,
              range = {
                start = {
                  line = request.context.cursor.row - 1,
                  character = request.context.cursor.col - 1 - #input,
                },
                ['end'] = {
                  line = request.context.cursor.row - 1,
                  character = request.context.cursor.col - 1,
                },
              },
            },
          }
        )
      end
      callback {
        items = items,
        isIncomplete = true,
      }
    else
      callback({isIncomplete = true})
    end
  end

  cmp.register_source('beancount-accounts', source.new())

  cmp.setup.filetype('beancount', {
    sources = cmp.config.sources({
      { name = 'luasnip' },
      { name = 'buffer' },

      -- My custom sources.
      { name = 'beancount-accounts' }, -- GitHub handles; eg. @wincent → Greg Hurrell <wincent@github.com>
    }),
  })
end

return M
