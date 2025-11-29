local M = {}

--- @class DiffOpts
--- @field unified? boolean
--- @field position? "left" | "right" | "above" | "below" | "tab"
--- @field cursorline? boolean
M.opts = {}

function M.diff(call, opts)
    require("diff.impl")(call, opts or M.opts)
end

vim.api.nvim_create_user_command("Diff", M.diff, {
    range = "%",
    nargs="?",
    complete="file",
})

--- @param opts DiffOpts
function M.setup(opts)
    M.opts = opts or {}
end

return M
