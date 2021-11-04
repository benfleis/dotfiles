function get_buf_dir()
    -- get expand('%:h') if buffer has filename, otherwise use $CWD
    local sibling = vim.fn.expand('%:h')
    if (sibling ~= nil and sibling ~= '') then
        return sibling
    end
    return vim.fn.getcwd()
end
