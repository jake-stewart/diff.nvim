return function(call, opts)
    local unified = opts.unified
    local cursorline = opts.cursorline == true
    local selection = vim.api.nvim_buf_get_lines(0, call.line1 - 1, call.line2, true)

    local lines
    if #call.args > 0 then
        if vim.startswith(call.args, "@") then
            lines = vim.fn.getreginfo(call.args).regcontents
        else
            lines = vim.fn.readfile(call.args)
        end
    elseif vim.o.clipboard:find("unnamedplus") then
        lines = vim.fn.getreginfo("+").regcontents
    elseif vim.o.clipboard:find("unnamed") then
        lines = vim.fn.getreginfo("*").regcontents
    else
        lines = vim.fn.getreginfo("").regcontents
    end

    local buffers = {
        vim.api.nvim_create_buf(false, true),
        vim.api.nvim_create_buf(false, true)
    }

    vim.api.nvim_buf_set_lines(buffers[1], 0, -1, true, selection)
    vim.api.nvim_buf_set_lines(buffers[2], 0, -1, true, lines)

    local windows = {
        vim.api.nvim_open_win(buffers[1], true, {
            win = -1,
            split = opts.split or "below",
        })
    }

    if not cursorline then
        vim.wo.cursorline = false
    end
    vim.cmd.diffthis()

    if unified then
        vim.api.nvim_win_set_buf(windows[1], buffers[2])
    else
        table.insert(windows, vim.api.nvim_open_win(
            buffers[2], true, { split = "right", }))
    end

    if not cursorline then
        vim.wo.cursorline = false
    end
    vim.cmd.diffthis()

    local has_vscode_diff, vscode_diff = pcall(
        require, "vscode-diff.diff")
    if has_vscode_diff and not unified then
        local diff = vscode_diff.compute_diff(selection, lines)
        local render = require("vscode-diff.render")
        render.setup_highlights()
        render.render_diff(buffers[1], buffers[2], selection, lines, diff)
    end

    local autocmd_id

    local function on_bufenter()
        local should_close = false
        for _, win in ipairs(windows) do
            if not vim.api.nvim_win_is_valid(win) then
                should_close = true
                break
            end
        end
        if not should_close then
            should_close = true
            for _, buf in ipairs(buffers) do
                if not vim.api.nvim_buf_is_loaded(buf) then
                    should_close = true
                    break
                end
                if buf == vim.api.nvim_get_current_buf() then
                    should_close = false
                end
            end
        end
        if not should_close then
            return
        end
        vim.api.nvim_del_autocmd(autocmd_id)
        for _, win in ipairs(windows) do
            pcall(vim.api.nvim_win_close, win, true)
        end
        for _, buf in ipairs(buffers) do
            pcall(vim.api.nvim_buf_delete, buf, { force = true })
        end
    end

    autocmd_id = vim.api.nvim_create_autocmd("BufEnter", {
        callback = on_bufenter,
    })
end
