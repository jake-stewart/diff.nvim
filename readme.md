# diff.nvim
View a diff of only the visual selection against another file or register.
Supports and automatically uses [vscode-diff.nvim](esmuellert/vscode-diff.nvim) if it is installed.

### usage

- `:Diff` to diff the file/selection against default register (respects `'clipboard'`).
- `:Diff @r` to diff the file/selection against register `r`.
- `:Diff file` to diff the file/selection against `file`.

## setup (lazy.nvim)

```
return {
    "jake-stewart/diff.nvim",
    cmd = "Diff",
    opts = {
        unified = false,
        split = "below",
        cursorline = false
    }
}
```
