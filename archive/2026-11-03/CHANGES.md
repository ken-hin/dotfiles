# Dotfile fixes, 2026-11-03

Everything that was replaced, moved or edited. Nothing was deleted.

## How to undo something

- A file listed under "Replaced": copy it back from `before-fixes/` to the path shown.
- A file listed under "Edited in place": the before/after lines are shown below; put the old lines back.
- `leftovers/` holds files that were just clutter. Delete the folder whenever you're sure you don't need them.

## Replaced (originals in before-fixes/)

| File | What changed |
| --- | --- |
| `~/.zshrc` | One theme block instead of four (same look). fzf and zoxide now load after Oh My Zsh, so fzf's Ctrl-R works. Docker completions added to fpath before Oh My Zsh; the second `compinit` is gone. Added `EDITOR`/`VISUAL=nvim`. `nvfig` opens `~/.config/nvim`. Removed dead Flutter and Android PATH lines and the duplicate `~/.local/bin`. `dud` error says "dud:" now. |
| `~/.zprofile` | Removed the dead Android SDK and Python 3.12 PATH lines. Same PATH order otherwise. |
| `~/.config/nvim/lua/plugins/lualine.lua` | Now edits LazyVim's statusline instead of replacing it, so root dir and diagnostics are back. Clock shows month/day (`%m/%d`) instead of month/year. Removed the empty winbar block and the unused lspkind dependency. |
| `~/.config/nvim/lua/plugins/render-markdown.lua` | Trimmed from ~400 lines to the 7 settings that differ from defaults. Same rendering. Dropped `pipe_table.wrap`, which isn't a real option. |
| `~/.config/nvim/lua/plugins/treesitter-context.lua` | Removed the `<leader>uC` mapping so LazyVim's colorscheme picker works again. Toggle is `<leader>ut`. |
| `~/.config/nvim/lua/config/autocmds.lua` | Auto-cd kept, but now escapes the path (folders with spaces work) and skips unnamed buffers and folders that don't exist yet. |
| `~/.config/nvim/lua/plugins/snacks.lua` | Removed entirely. Its explorer overrides aren't needed once the snacks explorer extra is off, and `<leader>ff`/`<leader>fF` are back to LazyVim's defaults (ff = whole project, fF = cwd). |

## Edited in place

`~/.config/nvim/lazyvim.json`: removed two extras.

```
-    "lazyvim.plugins.extras.editor.snacks_explorer",
-    "lazyvim.plugins.extras.util.project"
```

Note: with both explorer extras listed, LazyVim was picking snacks and skipping the neo-tree extra. Now the neo-tree extra actually loads (adds `<leader>ge`, `<leader>be`, `Y`, `O` in the tree, and opens the tree on `nvim .`).

`~/.config/nvim/lua/plugins/neo-tree.lua`: removed the custom `file_renamed` / `file_moved` handlers, since the neo-tree extra now does LSP-aware renames itself. Fixed the comment about switching tabs (`<Tab>` / `<`, not `<` / `>`).

`~/.config/nvim/.neoconf.json`: removed the old `neodev` block.

```
-  "neodev": {
-    "library": {
-      "enabled": true,
-      "plugins": true
-    }
-  },
```

`~/.config/nvim/lua/config/keymaps.lua`: comment now says better-escape handles `jj` and `jk` within 400 ms. `<leader>ee` description says "project root" instead of "cwd".

`~/.config/nvim/lua/plugins/better-escape.lua`: comments now label `jk` and `jj` correctly.

## Moved to leftovers/

`~/.zsh` (unused file with broken python aliases), `~/.zshrc.bak.20261028233142`, `~/.zshrc.bak.20261028233306`, `~/.zshrc.bak.20261028233735`, `~/.zshrc.bak.20261030102809`, `~/.zshrc.pre-oh-my-zsh`, `~/.zprofile.pysave`, `~/.config/nvim.bak`.

## Still to do on your Mac

1. `brew install lazygit` (turns on `<leader>gg` in Neovim).
2. Open a new Ghostty tab (or run `exec zsh`) to load the new shell config.
3. In Neovim, run `:Lazy` and press `X` to clean out project.nvim and lspkind-nvim, which nothing uses now.
