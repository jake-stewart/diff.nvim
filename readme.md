# diff.nvim
Allows you to diff your visual selection against another file or register.
Supports and automatically uses [vscode-diff.nvim](esmuellert/vscode-diff.nvim) if it is installed.

https://github.com/user-attachments/assets/fdf0785f-e20d-46a1-b9aa-fd9076f176cc

### usage

- `:Diff` to diff against default register (respects `'clipboard'`).
- `:Diff @r` to diff against register `r`.
- `:Diff file` to diff against file `file`.

## setup (lazy.nvim)

```lua
return {
    "jake-stewart/diff.nvim",
    cmd = "Diff",
    opts = {
        -- show a unified diff (single pane)
        unified = false,

        -- either "tab", "above", "below", "left", or "right"
        position = "below",

        -- show the cursorline within the diff windows
        cursorline = false
    }
}
```
