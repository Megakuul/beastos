# Git conflict browser

Local plugin for Neovim 0.10+ and Git, with no plugin dependencies. This config
loads `require("git_conflict_browser").setup()` from `lua/mappings.lua`, after
NvChad's mappings. Open with `:GitConflictBrowser` or `<leader>gc` (Space, g, c).
An existing mapping is preserved and reported; the command remains available.

| Key | Action |
| --- | --- |
| `j` / Down | Next conflict (counts supported) |
| `k` / Up | Previous conflict (counts supported) |
| `o` | Keep the entire stage-2 file (ours), then stage it |
| `t` | Keep the entire stage-3 file (theirs), then stage it |
| Enter | Open the file in the original editing window |
| `a` | Stage the selected manual resolution |
| `d` | Confirm resolution as deleted (`git rm -- path`) |
| `r` | Refresh from Git, keeping the selected path when possible |
| `q` | Close and return to the original window |
| `?` | Show help |

After Enter, edit and `:write`, then return using `<C-w>p` or
`:GitConflictBrowser`. Selection is retained. Press `a` to stage that file.
Unsaved buffers require explicit save-first confirmation. Remaining conflict
markers require a separate confirmation (default No). Missing files require `d`.
Whole-file replacement/deletion asks before discarding modified buffers, and
reloads loaded buffers after changing disk. No action stages another path.

**Ours always means index stage 2; theirs always means stage 3.** During rebase,
ours is the rebased-onto side and theirs is the commit being replayed. A missing
side is not an instruction to delete: use `d` explicitly. Binary files can be
resolved without opening them. Manual staging skips marker checks for files
containing NUL bytes or marked `-diff` (including `binary`) in Git attributes.
For opaque formats without NUL bytes, declare `-diff` in `.gitattributes`.

Paths are passed as literal argv pathspecs; unmerged records use NUL delimiters.
Tabs/newlines in names are escaped only for display. The repository is detected
from the current buffer, falling back to cwd. An already-open browser is focused
on subsequent invocations; close it before switching repositories.

Configuration (replace the existing setup call):

```lua
require("git_conflict_browser").setup {
  mapping = "<leader>gc", -- false disables the global mapping
  window = { height = 14, position = "botright" }, -- or "topleft"
  keymaps = {
    ours = "o", theirs = "t", edit = "<CR>", stage = "a",
    delete = "d", refresh = "r", close = "q", help = "?",
  }, -- individual keys may be false to disable them
}
```

Git commands run synchronously; very large files/repos and Git filters can pause
Neovim. Checkout uses Git's normal worktree conversion/filter rules. Submodule
side selection is deliberately rejected: resolve the submodule manually, then
stage it. The browser does not lock out other Git clients; refresh after external
changes. A checkout can succeed while `git add` fails: the disk/buffer then holds
the chosen version, the error is shown, and the conflict remains available.

Run the dependency-free smoke tests from this configuration directory:

```sh
nvim --headless -u NONE -i NONE -l tests/git_conflict_browser.lua
```

Tests create and remove a temporary repository outside this project. They cover
real text/binary merges, exact binary stage bytes, unusual filenames, isolated
staging, selection/navigation/counts, manual editing, confirmations, deletion,
refresh failures, no-repo/no-conflict states, and mapping preservation.
