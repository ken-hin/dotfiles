# Neovim Reference

Kenneth's Neovim setup (LazyVim 16, Neovim 0.12.6) as of 2026-11-03, after the config cleanup. Re-checked 2026-11-13: no config changes since then.
Companion sheets: [ZSH.md](ZSH.md), [CLAUDE-CODE.md](CLAUDE-CODE.md).
Leader is `Space`. Localleader is `\`.

Forgot a key? Press `Space` and wait for the which-key menu, or:

- `<leader>sk` search every keymap
- `<leader>?` keys for the current buffer
- `<leader>sh` search help pages
- `:Lazy`, `:LazyExtras`, `:Mason`, `:checkhealth`

Modes in the tables: n = normal, i = insert, x = visual, o = after an operator like `d` or `y`.

## Contents

1. [Config files](#config-files)
2. [Options and behavior](#options-and-behavior)
3. [Your custom keys](#your-custom-keys)
4. [Windows and splits](#windows-and-splits)
5. [Buffers](#buffers)
6. [Editing](#editing)
7. [Finding things](#finding-things)
8. [neo-tree (file explorer)](#neo-tree-file-explorer)
9. [Harpoon](#harpoon)
10. [Git](#git)
11. [Diagnostics, quickfix, todos](#diagnostics-quickfix-todos)
12. [LSP and code actions](#lsp-and-code-actions)
13. [Toggles](#toggles)
14. [Terminal, tabs, sessions, misc](#terminal-tabs-sessions-misc)
15. [Plugins](#plugins)
16. [Languages](#languages)
17. [Outside tools Neovim uses](#outside-tools-neovim-uses)
18. [Changes made 2026-11-03](#changes-made-2026-11-03)

## Config files

> All of these files now live in `~/dotfiles` (symlinked into place). See `~/dotfiles/README.md`.

| File | What it controls |
| --- | --- |
| `~/.config/nvim/init.lua` | Starts lazy.nvim, which loads LazyVim, then your plugins |
| `lua/config/options.lua` | Editor options (scrolloff, line numbers) |
| `lua/config/keymaps.lua` | Your custom keys (buffer cycling, explorer) |
| `lua/config/autocmds.lua` | Auto-cd into each file's folder |
| `lua/config/lazy.lua` | Plugin manager setup and the background update checker |
| `lua/plugins/*.lua` | Your 9 plugin specs, one per file |
| `lazyvim.json` | Which LazyVim Extras are on (change with `:LazyExtras`) |
| `lazy-lock.json` | Pinned plugin versions |

`nvfig` in the shell opens this folder in Neovim.

## Options and behavior

- `scrolloff = 999`: the cursor line stays centered on screen.
- `number` + `relativenumber`: the current line shows its real number, others show distance (use with `5j`, `12k`).
- Auto-cd: entering a file sets that window's cwd to the file's folder. Terminals, `:!` commands and the "cwd" pickers start there. The project pickers (`<leader>ff`, `<leader><space>`, `<leader>/`) still search the whole project.
- neo-tree also `cd`s Neovim to the tree's root when you click into the tree.
- Plugin updates are checked in the background with no popups. `:Lazy` shows anything pending.
- Colorscheme is tokyonight (Ghostty uses the same theme). catppuccin is installed too.

## Your custom keys

| Keys | Mode | What it does |
| --- | --- | --- |
| `jj` or `jk` | i | Escape (second key within 400 ms) |
| `<Tab>` / `<S-Tab>` | n | Next / previous buffer |
| `<leader>ee` | n | Toggle neo-tree at the project root |
| `<leader>er` | n | Toggle neo-tree at your home folder |
| `<leader>ef` | n | Toggle neo-tree at the current file's folder |
| `w` `e` `b` | n, o, x | Sub-word motions: stop inside camelCase and snake_case |
| `<leader>ha` `hh` `hn` `hp` | n | Harpoon add / menu / next / prev |
| `<C-1>` to `<C-4>` | n | Harpoon jump to slot 1 to 4 |

## Windows and splits

| Keys | What it does |
| --- | --- |
| `<C-h>` `<C-j>` `<C-k>` `<C-l>` | Move to the window left / down / up / right (works from a terminal too) |
| `<C-Up>` `<C-Down>` `<C-Left>` `<C-Right>` | Resize the window |
| `<leader>-` / `<leader>\|` | Split below / split right |
| `<leader>wd` | Close window |
| `<leader>wm` or `<leader>uZ` | Zoom window (toggle) |
| `<C-w><space>` | Window "hydra": keep pressing window keys without repeating `<C-w>` |

## Buffers

The tabs along the top are buffers (open files).

| Keys | What it does |
| --- | --- |
| `<Tab>` / `<S-Tab>`, `<S-h>` / `<S-l>`, `[b` / `]b` | Previous / next buffer |
| `<leader>bb` or `` <leader>` `` | Jump to the last buffer you were in |
| `<leader>bd` | Close this buffer |
| `<leader>bo` | Close every other buffer |
| `<leader>br` / `<leader>bl` | Close buffers to the right / left |
| `<leader>bp` | Pin buffer. `<leader>bP` closes everything not pinned |
| `[B` / `]B` | Move this buffer left / right in the bar |
| `<leader>bj` | Pick a buffer by letter |
| `<leader>,` or `<leader>fb` | Fuzzy-find open buffers |
| `<leader>be` | Buffers as a neo-tree list |

## Editing

| Keys | Mode | What it does |
| --- | --- | --- |
| `<A-j>` / `<A-k>` | n, i, x | Move line or selection down / up (Option+j / Option+k) |
| `<C-s>` | any | Save |
| `gcc` / `gc{motion}` | n, x | Toggle comment on line / motion / selection |
| `gco` / `gcO` | n | Add a comment line below / above |
| `<` / `>` | x | Indent and keep the selection |
| `<C-a>` / `<C-x>` | n, x | Increment / decrement (numbers, dates, true/false, `&&`/`\|\|`, let/const, weekdays, months, `[ ]`/`[x]`) |
| `s` | n, x, o | Flash jump: type a few letters, then the label |
| `S` | n, x, o | Flash select a Treesitter node (function, block, ...) |
| `r` | o | Remote flash: `yr` yanks something elsewhere without moving |
| `<C-space>` | n, x, o | Grow selection by Treesitter node, `<BS>` shrinks |
| `<esc>` | n | Also clears search highlight |
| `n` / `N` | n | Next / previous match, always the same direction |
| `<leader>p` | n, x | Yank history picker |
| `[y` / `]y` | n | Right after a paste: swap in an older / newer yank |
| `]p` / `[p` | n | Paste on a new line below / above, matching indent |

Text objects from mini.ai (use after `v`, `d`, `c`, `y` plus `a` or `i`): `f` function, `c` class, `a` argument, `q` quote, `b` brackets, `t` tag, `o` block or loop, `i` indent, `g` whole file. Example: `daf` deletes a function, `ci"` changes inside quotes.

## Finding things

| Keys | Finds |
| --- | --- |
| `<leader>ff` or `<leader><space>` | Files in the whole project |
| `<leader>fF` | Files in cwd (the current file's folder) |
| `<leader>fr` / `<leader>fR` | Recent files / recent files in cwd |
| `<leader>fg` | Git-tracked files |
| `<leader>fc` | Your Neovim config files |
| `<leader>fp` | Projects |
| `<leader>/` or `<leader>sg` | Grep text in the project. `<leader>sG` greps cwd |
| `<leader>sw` | Grep the word under the cursor (or the selection) |
| `<leader>sb` | Lines in this buffer |
| `<leader>sr` | Search and replace across files (grug-far) |
| `<leader>ss` / `<leader>sS` | Symbols in this file / the whole workspace |
| `<leader>sd` / `<leader>sD` | Diagnostics, all / this buffer |
| `<leader>sk` / `<leader>sh` | Keymaps / help pages |
| `<leader>su` | Undo history tree |
| `<leader>s"` / `<leader>sm` / `<leader>sj` | Registers / marks / jump list |
| `<leader>sc` / `<leader>sC` | Command history / all commands |
| `<leader>sR` | Reopen the last picker where you left it |
| `<leader>uC` | Colorschemes (live preview) |

Inside any picker: type to filter, `<C-j>` / `<C-k>` or arrows to move, `<CR>` to open, `<a-c>` to flip between project root and cwd, `<a-t>` to send results to Trouble, `<esc>` to close.

## neo-tree (file explorer)

Open it with `<leader>ee` (project root), `<leader>er` (home) or `<leader>ef` (current file's folder). The same key closes it. `nvim .` or `:e some/folder` opens it too.

The tree has three tabs at the top: Files, Bufs, Git. `<leader>ge` opens the Git tab as a float and `<leader>be` opens Bufs.

| Key | Action |
| --- | --- |
| `l` / `<CR>` | Open file or expand folder |
| `h` | Collapse folder |
| `<BS>` / `.` | Go up a level / make this folder the root |
| `a` | New file (end the name with `/` for a folder) |
| `A` | New folder |
| `r` | Rename (LSP updates imports in other files) |
| `d` | Move to the macOS Trash, with a confirm prompt |
| `y` / `x` / `p` | Copy / cut / paste |
| `c` / `m` | Copy to / move to a typed path |
| `Y` | Copy the full path to the clipboard |
| `O` | Open with the default macOS app |
| `P` | Floating preview |
| `f` / `<C-x>` | Filter by name / clear the filter |
| `H` | Show or hide dotfiles (they show dimmed by default) |
| `<Tab>` / `<` | Next / previous tab (Files, Bufs, Git) |
| `R` / `q` / `?` | Refresh / close / show every key |

The tree follows the file you're editing. Its root stays where you opened it; it doesn't jump when Neovim's cwd changes.

## Harpoon

Pin a few files per project and jump straight to them.

- `<leader>ha` adds the current file to this project's list.
- `<leader>hh` opens the list. Edit it like text: reorder lines, `dd` to remove, `q` to close.
- `<leader>hn` / `<leader>hp` step through the list.
- `<C-1>` to `<C-4>` jump to slots 1 to 4. These work in Ghostty. Terminal.app doesn't send Ctrl+number, so use the menu there.

## Git

| Keys | What it does |
| --- | --- |
| `]h` / `[h` | Next / previous changed hunk (`]H` / `[H` last / first) |
| `<leader>ghs` / `<leader>ghr` | Stage / reset hunk (works on a selection too) |
| `<leader>ghS` / `<leader>ghR` | Stage / reset the whole file |
| `<leader>ghu` | Undo the last stage |
| `<leader>ghp` | Preview hunk inline |
| `<leader>ghb` / `<leader>ghB` | Blame line (full) / blame the whole file |
| `<leader>ghd` | Diff this file against the index |
| `ih` | Text object: the hunk under the cursor (`vih`, `dih`) |
| `<leader>gs` | Git status picker |
| `<leader>gd` | Changed hunks picker |
| `<leader>gl` / `<leader>gL` | Git log (project / cwd) |
| `<leader>gf` | History of the current file |
| `<leader>gb` | Blame the current line |
| `<leader>gB` / `<leader>gY` | Open the file on GitHub / copy the GitHub link |
| `<leader>gi` / `<leader>gp` | GitHub issues / pull requests |
| `<leader>ge` | Git status as a neo-tree float |
| `<leader>gg` / `<leader>gG` | lazygit (project / cwd) |
| `<leader>uG` | Toggle git signs in the gutter |

## Diagnostics, quickfix, todos

| Keys | What it does |
| --- | --- |
| `]d` `[d` | Next / previous diagnostic |
| `]e` `[e` / `]w` `[w` | Next / previous error / warning |
| `<leader>cd` | This line's diagnostics in a float |
| `<leader>xx` / `<leader>xX` | Trouble: all diagnostics / this buffer's |
| `<leader>xq` / `<leader>xl` | Toggle quickfix / location list |
| `<leader>xQ` / `<leader>xL` | Quickfix / location list in Trouble |
| `]q` / `[q` | Next / previous quickfix or Trouble item |
| `]t` / `[t` | Next / previous TODO, FIX, HACK or NOTE comment |
| `<leader>xt` / `<leader>st` | Todos in Trouble / in the picker |

## LSP and code actions

These show up once a language server attaches. `<leader>cl` shows which servers are running.

| Keys | Mode | What it does |
| --- | --- | --- |
| `gd` | n | Go to definition |
| `gr` | n | List references |
| `gI` / `gy` / `gD` | n | Go to implementation / type definition / declaration |
| `K` | n | Hover docs (`<C-f>` / `<C-b>` scroll them) |
| `gK` / `<C-k>` | n / i | Signature help |
| `]]` / `[[` | n | Next / previous use of the word under the cursor (`<A-n>` / `<A-p>` too) |
| `gai` / `gao` | n | Incoming / outgoing calls |
| `<leader>ca` | n, x | Code action (quick fixes) |
| `<leader>cA` | n | Source action |
| `<leader>co` | n | Organize imports (when the server supports it) |
| `<leader>cr` | n | Rename symbol everywhere |
| `<leader>cR` | n | Rename the file and update imports |
| `<leader>cs` | n | Symbol outline sidebar |
| `<leader>cf` | n, x | Format now |
| `<leader>ch` | n | C/C++: switch between source and header |
| `<leader>cv` | n | Python: pick a virtualenv |

Formatting runs on save (conform.nvim). `:ConformInfo` shows which formatter a file uses. Linting runs through nvim-lint.

Completion (blink.cmp): `<CR>` accept, `<C-space>` open menu or docs, `<C-e>` close, `<C-n>` / `<C-p>` move, `<C-b>` / `<C-f>` scroll docs, `<Tab>` / `<S-Tab>` jump through snippet fields.

## Toggles

All under `<leader>u`.

| Keys | Toggles |
| --- | --- |
| `uf` / `uF` | Format on save (global / this buffer) |
| `us` / `uw` | Spell check / line wrap |
| `ul` / `uL` | Line numbers / relative numbers |
| `ud` / `uh` | Diagnostics / inlay hints |
| `ut` / `uT` | Sticky context header / Treesitter highlighting |
| `ug` / `ua` / `uS` | Indent guides / animations / smooth scroll |
| `uz` / `uD` / `ub` | Zen mode / dim inactive code / dark or light background |
| `uc` / `uA` / `uG` | Conceal / tabline / git signs |
| `un` / `ur` | Dismiss notifications / redraw and clear search |
| `ui` / `uI` | Inspect highlight under cursor / Treesitter tree |
| `uC` | Pick a colorscheme |

## Terminal, tabs, sessions, misc

| Keys | What it does |
| --- | --- |
| `<C-/>` | Toggle a floating terminal at the project root (also hides it from inside) |
| `<leader>ft` / `<leader>fT` | Terminal at project root / cwd |
| `<leader><tab><tab>` | New tab page. `<leader><tab>]` / `[` next / prev, `d` close, `o` close others |
| `<leader>qs` / `<leader>ql` / `<leader>qS` | Restore this folder's session / last session / pick one |
| `<leader>qd` | Don't save this session on exit |
| `<leader>qq` | Quit everything |
| `<leader>.` / `<leader>S` | Scratch buffer / pick a scratch buffer |
| `<leader>fn` | New empty file |
| `<leader>n` | Notification history |
| `<leader>snh` / `snl` / `snd` | Message history / last message / dismiss all |
| `<leader>l` / `<leader>L` | Lazy plugin manager / LazyVim changelog |
| `<leader>ac` | Toggle Claude Code (see Plugins) |

## Plugins

### Your plugin specs (`lua/plugins/`)

| File | What it's for | How to use it |
| --- | --- | --- |
| `neo-tree.lua` | File explorer: Files, Bufs and Git tabs, deletes go to Trash, size and date columns | `<leader>ee` / `er` / `ef`, keys above |
| `harpoon2.lua` | Per-project file bookmarks | `<leader>ha`, `<leader>hh`, `<C-1>` to `<C-4>` |
| `nvim-spider.lua` | `w` `e` `b` stop at sub-words (`some\|Long\|Name`) | Just move. `ciw` still grabs the whole word |
| `better-escape.lua` | `jj` / `jk` leave insert mode without lag on a single `j` | Type the pair within 400 ms |
| `treesitter-context.lua` | Sticky header showing the function or class you're in (max 3 lines) | `<leader>ut` |
| `render-markdown.lua` | Draws headings, tables, checkboxes and code blocks nicely in `.md` files. Heavy table borders, content indented under headings | `:RenderMarkdown toggle` shows raw text |
| `lualine.lua` | Statusline: mode, branch, project, diagnostics, file name with `[+]` when unsaved, LSP breadcrumbs, `03:15 PM \| 11/03` clock | Nothing to press |
| `noice.lua` | Message and cmdline popups. Yours wraps long messages | `<leader>snh` history |
| `which-key.lua` | The popup when you press `Space`. Adds the explorer and harpoon groups | `<leader>?` |

### LazyVim Extras turned on (19)

Change these with `:LazyExtras` (`x` toggles the one under the cursor).

| Extra | What you get | Keys / commands |
| --- | --- | --- |
| `ai.claudecode` | Claude Code inside Neovim | `<leader>ac` toggle, `af` focus, `ar` resume, `aC` continue, `ab` add buffer, `as` send selection (or add file from neo-tree), `aa` / `ad` accept / deny a diff |
| `coding.yanky` | Yank history | `<leader>p`, `[y` / `]y`, `]p` / `[p`, `>p` / `<p` paste and shift |
| `editor.dial` | Smarter `<C-a>` / `<C-x>` | See Editing |
| `editor.neo-tree` | The explorer, plus `<leader>ge`, `<leader>be`, `Y`, `O` | See neo-tree |
| `editor.outline` | Symbol outline sidebar | `<leader>cs` |
| `lang.clangd` | C/C++ LSP with clang-tidy | `<leader>ch` |
| `lang.python` | pyright + ruff, venv picker | `<leader>cv` |
| `lang.docker`, `lang.git`, `lang.json`, `lang.svelte`, `lang.tailwind` | LSPs and highlighting for those files (JSON gets schema checks) | Automatic |
| `linting.eslint` | ESLint for JS/TS | Automatic |
| `ui.dashboard-nvim` | Start screen | Single-letter keys on screen (`p` projects, `s` restore session) |
| `ui.indent-blankline` | Indent guides | `<leader>ug` |
| `ui.mini-animate` | Cursor, scroll and resize animations | `<leader>ua` |
| `ui.treesitter-context` | Sticky context | `<leader>ut` |
| `util.dot` | Better highlighting for dotfiles and shell configs | Automatic |
| `util.mini-hipatterns` | Colors hex codes like `#ff5500` inline | Automatic |

### LazyVim built-ins worth knowing

| Plugin | What it does | Keys |
| --- | --- | --- |
| blink.cmp | Autocomplete | See LSP section |
| snacks.nvim | Picker, notifications, terminal, scratch buffers, dashboard pieces, toggles | `<leader>f…`, `<leader>s…`, `<leader>u…` |
| gitsigns | Git changes in the gutter | See Git |
| flash | Jump anywhere on screen | `s`, `S`, `r`, `R` |
| trouble | Lists for diagnostics, symbols, quickfix | `<leader>x…` |
| todo-comments | Highlights TODO, FIX, HACK, NOTE | `]t` / `[t`, `<leader>st` |
| mini.ai | Extra text objects | See Editing |
| mini.pairs | Auto-closes brackets and quotes | Automatic |
| nvim-ts-autotag | Auto-closes and renames HTML/Svelte tags | Automatic |
| persistence | Saves sessions per folder | `<leader>qs`, `ql`, `qS` |
| bufferline | The buffer tabs at the top | See Buffers |
| conform / nvim-lint | Format on save / linting | `<leader>cf`, `:ConformInfo` |
| mason | Installs LSPs, formatters, linters | `:Mason` |
| tokyonight | Colorscheme | `<leader>uC` to try others |

## Languages

| Language | Language server | Comes from |
| --- | --- | --- |
| C / C++ | clangd (clang-tidy, header insertion) | `lang.clangd` |
| Python | pyright for types, ruff for lint and format | `lang.python` |
| Svelte | svelte | `lang.svelte` |
| Tailwind classes | tailwindcss | `lang.tailwind` |
| JSON | jsonls with SchemaStore schemas | `lang.json` |
| Dockerfile, compose | Docker language servers | `lang.docker` |
| JS / TS linting | eslint | `linting.eslint` |
| Lua (your config) | lua_ls with lazydev | LazyVim core |
| Git commit messages | Treesitter highlighting | `lang.git` |

Commands to remember:

- `:Mason`: `i` install, `u` update, `X` uninstall.
- `:LazyExtras`: `x` toggles the extra under the cursor.
- `:Lazy`: `U` update, `C` check for updates, `X` clean unused plugins, `S` sync everything.
- `:checkhealth` finds missing tools. `:LazyHealth` loads every plugin first.

## Outside tools Neovim uses

| Tool | Used for | Installed? |
| --- | --- | --- |
| ripgrep (`rg`) | `<leader>/`, `<leader>sg` and the other grep pickers | Yes (Homebrew) |
| fd | `<leader>ff` and the other file pickers | Yes (Homebrew) |
| trash | `d` in neo-tree sends files to the macOS Trash | Yes (built into macOS) |
| lazygit | `<leader>gg` / `<leader>gG` | Yes (Homebrew, in the Brewfile) |
| claude | `<leader>ac` | Yes (`~/.local/bin`) |

## Changes made 2026-11-03

Originals are in `~/dotfiles/archive/2026-11-03/before-fixes/`, with details in `CHANGES.md` there.

- `<leader>ff` and `<leader><space>` search the whole project again. `<leader>fF` searches the current file's folder.
- Auto-cd works with folder names that have spaces and skips folders that don't exist yet.
- `<leader>uC` is the colorscheme picker again. Sticky context toggles with `<leader>ut`.
- The statusline has the project name and diagnostic counts back. The clock shows month/day.
- Turned off the `editor.snacks_explorer` and `util.project` extras. That made LazyVim's neo-tree extra load for real (it was being skipped), which adds `<leader>ge`, `<leader>be`, `Y` and `O`.
- Removed `snacks.lua` (nothing left in it was needed) and the duplicate rename handlers in `neo-tree.lua`.
- `render-markdown.lua` trimmed to the 7 settings that differ from defaults.
- Fixed comments in `keymaps.lua`, `better-escape.lua` and `neo-tree.lua`. Removed the old `neodev` block from `.neoconf.json`.

2026-11-13: lazygit installed; project.nvim and lspkind-nvim removed with `:Lazy` → `X`.
