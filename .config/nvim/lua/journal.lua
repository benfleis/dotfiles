-- beginnings of improved daily logging; currently playing with using neorg as
-- my frontend to note taking, but adding these funcs to support my personal
-- navigations (today, tomorrow-weekday, etc.) in a way that can work with
-- others.

local assert = require('luassert')
local path = require('plenary.path')
local log = require('vlog')
local journal = {}

log.new({ plugin = 'journal', })

function journal.get_path_from_time(t)
    t = t or os.time()
    return os.date('%Y/%m/%Y-%m-%d.norg', t)
end

function journal.get_time_from_path(p)
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

function journal.get_next_weekday(t)
    t = t or os.time()
    repeat
        t = t + (60 * 60 * 24)
    until is_weekday(t)
    return t
end

function journal.get_previous_weekday(t)
    t = t or os.time()
    repeat
        t = t - (60 * 60 * 24)
    until is_weekday(t)
    return t
end


function journal.get_next_weekday_from_path(p)
    return journal.get_next_weekday(journal.get_time_from_path(p))
end

function journal.get_previous_weekday_from_path(p)
    return journal.get_previous_weekday(journal.get_time_from_path(p))
end

-- calc next weekday, and open that file whether or not it exists
function journal.edit_next_weekday_from_path(p)
    vim.cmd("edit " .. journal.get_path_from_time(journal.get_next_weekday_from_path()))
end

function journal.edit_previous_weekday_from_path(p)
    vim.cmd("edit " .. journal.get_path_from_time(journal.get_previous_weekday_from_path()))
end

-- given a sequence of times, for each: convert to entry path, attempt to fstat
-- it, and if successful return the entry path; if none succeeds, return nil
function _find_next_entry_from_time_seq(seq)
    for i=1,#seq do
        local entry = journal.get_path_from_time(seq[i])
        local stat = vim.loop.fs_stat(entry)
        if stat then
            log.debug("journal: found next entry:", entry)
            return entry
        end
    end
    log.debug("journal: found no next entry: [",
        journal.get_path_from_time(seq[1]), "..",
        journal.get_path_from_time(seq[#seq-1]), "]")
    return nil
end

local _find_entry_step_names = {[-1]="backward", [1]="forward"}

-- common code for finding entries, also handle UX (errors, calling `edit`)
-- p=entry (default expand('%')), step={-1,1}, max=[90]
function _find_entry_from(start, step, max_days)
    step = step or 1
    max_days = max_days or 90

    -- sanity check args so we don't run amok
    assert.True(step == -1 or step == 1)
    assert.True(max_days > 0 and max_days < 365 * 100)

    local time = journal.get_time_from_path(p)
    local days_seq = {}
    for i=1, max_days do
        days_seq[i] = time + (step * i * 60 * 60 * 24)
    end

    local entry = _find_next_entry_from_time_seq(days_seq)
    if entry == nil then
        error(string.format(
            "journal: Found no entries within %s days %s",
            max_reads, _find_entry_step_names[step]))
    else
        vim.cmd("edit " .. entry)
    end
    return entry
end

-- given path `p` which contains an individual journal entry, (p=nil -> use
-- vim.fn.expand('%')), find the previous one, attempting up to max=90 reads.
function journal.find_previous_entry(p, max_days)
    return _find_entry_from(p, -1, max_days)
end

-- given path `p` which contains an individual journal entry, (p=nil -> use
-- vim.fn.expand('%')), find the next one, attempting up to max=90 reads.
function journal.find_next_entry(p, max_days)
    return _find_entry_from(p, 1, max_days)
end

return journal
