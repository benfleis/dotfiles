-- beginnings of improved daily logging; currently playing with using neorg as
-- my frontend to note taking, but adding these funcs to support my personal
-- navigations (today, tomorrow-weekday, etc.) in a way that can work with
-- others.

local path = require('plenary.path')
local log_local = {}

function log_local.get_path_from_time(t)
    t = t or os.time()
    return os.date('%Y/%m/%Y-%m-%d.norg', t)
end

function log_local.get_time_from_path(p)
    p = p or vim.fn.expand('%')
    local pattern = "(%d+)/(%d+)/(%d+)-(%d+)-(%d+).norg"
    local y2, m2, year, month, day = p:match(pattern)
    -- assert y2 == year, m2 == month
    return os.time({year = year, month = month, day = day})
end

-- local
function is_weekday(t)
    w = tonumber(os.date('%w', t or os.time()))
    return w > 0 and w < 6
end

function log_local.get_next_weekday(t)
    t = t or os.time()
    repeat
        t = t + (60 * 60 * 24)
    until not is_weekday(t)
    return t
end


function log_local.get_next_weekday_from_path(p)
    return get_next_weekday(get_time_from_path(p))
end

return log_local
