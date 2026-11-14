# Zsh Reference

Kenneth's shell as of 2026-11-13 (checked against `~/.zshrc`): Oh My Zsh with 10 plugins, plus fzf, zoxide, eza and the modern-dark-pro-capsule prompt, running in Ghostty.
Companion sheets: [NEOVIM.md](NEOVIM.md), [CLAUDE-CODE.md](CLAUDE-CODE.md).
Each plugin has its own section covering what it does, every command or key it adds, and every setting you can change.

Quick lookups from the terminal:

- `als` lists every alias, grouped by the command it runs. `als push` searches, `als -g brew` shows one group.
- `which <name>` shows what a command, alias or function really is.
- `bindkey '^R'` shows what a key does. `bindkey` alone lists them all.
- `omz plugin list --enabled` lists your plugins; `omz plugin info <name>` shows one plugin's README.

After editing `~/.zshrc`: `omz reload` (or `shload`, or open a new tab).

## Contents

1. [Problems in the current setup](#problems-in-the-current-setup)
2. [Config files and load order](#config-files-and-load-order)
3. [Keys at a glance](#keys-at-a-glance)
4. [Your own aliases and functions](#your-own-aliases-and-functions)
5. [Oh My Zsh plugins](#oh-my-zsh-plugins)
    - [zsh-autosuggestions](#zsh-autosuggestions)
    - [zsh-syntax-highlighting](#zsh-syntax-highlighting)
    - [zsh-interactive-cd](#zsh-interactive-cd)
    - [zsh-navigation-tools](#zsh-navigation-tools)
    - [aliases](#aliases)
    - [brew](#brew)
    - [colored-man-pages](#colored-man-pages)
    - [colorize](#colorize)
    - [dirhistory](#dirhistory)
    - [docker-compose](#docker-compose)
6. [Shell tools loaded outside Oh My Zsh](#shell-tools-loaded-outside-oh-my-zsh)
    - [fzf](#fzf)
    - [zoxide](#zoxide)
7. [Prompt theme: modern-dark-pro-capsule](#prompt-theme-modern-dark-pro-capsule)
8. [Oh My Zsh itself](#oh-my-zsh-itself)
9. [PATH](#path)
10. [Other CLI tools](#other-cli-tools)
11. [Change log](#change-log)

## Problems in the current setup

None of these stop the shell from working, but they change how the plugins below behave.

| Problem | What you'll notice | Fix |
| --- | --- | --- |
| dirhistory owns Option-B, Option-F and Option-arrows | Those keys no longer move by word. They wipe what you typed and change folder | See [dirhistory](#dirhistory) |
| zsh-navigation-tools binds Ctrl-R, then fzf rebinds it | Ctrl-R is fzf's history search. ZNT's is `nhistory` | Nothing to do unless you prefer ZNT's |

## Config files and load order

> All of these files now live in `~/dotfiles` (symlinked into place). See `~/dotfiles/README.md`.

| File | What it controls |
| --- | --- |
| `~/.zprofile` | PATH: Docker, JetBrains Toolbox, Homebrew, Python 3.13, `~/.local/bin` |
| `~/.zshrc` | Oh My Zsh settings, the plugin list, theme settings, fzf, your aliases, bun, `dud`, zoxide |
| `~/.oh-my-zsh/plugins/<name>/` | Code and README for each of your 10 plugins |
| `~/.oh-my-zsh/custom/themes/modern-dark-pro-capsule.zsh-theme` | The prompt theme |
| `~/.config/znt/*.conf` | zsh-navigation-tools settings |
| `~/.config/ghostty/config` | Terminal. `macos-option-as-alt = true` makes Option work as Alt for every key below |
| `~/dotfiles/zsh/modern-dark-pro-capsule/` | The theme's repo, including `wizard.sh` |

What runs when you open a Ghostty tab:

1. `~/.zprofile` sets PATH.
2. The top of `~/.zshrc` sets Oh My Zsh options, the plugin list, the theme variables and the Docker completions folder.
3. `source $ZSH/oh-my-zsh.sh` loads Oh My Zsh's own settings and key bindings, then each plugin in list order, then the theme.
4. The rest of `~/.zshrc`: `EDITOR`, fzf (`source <(fzf --zsh)`), your aliases, bun, `dud`, and zoxide last.

When two things bind the same key, the one loaded later wins. That's why fzf's Ctrl-R beats zsh-navigation-tools'.

In the settings tables below, "before OMZ" means above the `source $ZSH/oh-my-zsh.sh` line and "after OMZ" means below it.

## Keys at a glance

Every key at the prompt and which plugin it comes from. Option works as Alt in Ghostty.

| Keys | What it does | From |
| --- | --- | --- |
| `Tab` | Complete. After `cd `, opens a fuzzy folder picker instead | Oh My Zsh, zsh-interactive-cd |
| `**` then `Tab` | Fuzzy-pick files below here (folders only after `cd`) | fzf |
| `Shift-Tab` | Move backward through the completion menu | Oh My Zsh |
| `Ctrl-R` | Fuzzy history search | fzf |
| `Ctrl-T` | Fuzzy-pick files and paste their paths | fzf |
| `Option-C` | Fuzzy-pick a folder and cd into it | fzf |
| Type a prefix, then `↑` / `↓` | Step through history entries that start with that prefix | Oh My Zsh |
| `→`, `End`, `Ctrl-E` or `Ctrl-F` | At the end of the line: accept the gray suggestion | zsh-autosuggestions |
| `Ctrl-→` | Accept one word of the suggestion (macOS may grab this key for switching Spaces) | zsh-autosuggestions |
| `Option-←` or `Option-B` | Back to the previous folder. Wipes the line | dirhistory |
| `Option-→` or `Option-F` | Forward again. Wipes the line | dirhistory |
| `Option-↑` / `Option-↓` | Parent folder / first subfolder. Wipes the line | dirhistory |
| `Ctrl-A` / `Ctrl-E` | Start / end of the line | zsh |
| `Ctrl-U` / `Ctrl-K` / `Ctrl-W` | Delete the whole line / to the end / the previous word | zsh |
| `Ctrl-←` | Back one word | Oh My Zsh |
| `Ctrl-X Ctrl-E` | Edit the current command in Neovim | Oh My Zsh |
| `Option-L` | Run `ls` without losing what you typed | Oh My Zsh |
| `Option-M` | Copy the previous word (`mv file ` then `Option-M` gives `mv file file`) | Oh My Zsh |
| `Option-W` | Cut from the cursor to the mark | Oh My Zsh |
| `Space` | Also expands history references like `!!` and `!$` | Oh My Zsh |
| `PageUp` / `PageDown` | Previous / next history entry | Oh My Zsh |

## Your own aliases and functions

| Alias | What it does |
| --- | --- |
| `lls [-L depth] [path ...]` | Tree-style long listing via the `lls_depth` function: `eza -T -a -l -h -m --total-size --icons=always --no-user`. Everything (dotfiles too) with icons, modified dates, a header row and folder sizes that include their contents (slower on big folders). Works like `ls`: `lls` lists here, `lls ~/foo bar/` lists those paths. Depth defaults to 1; set it with `-L 3`, `--level=3`, or a bare number (`lls 3 ~/foo`, `lls ~/foo 3`), range 1–5. A bare number is a path if a file or folder with that name exists; `lls -- 3` forces it. Other args go straight to eza. `lls --help` prints usage |
| `desk` | Go to Desktop |
| `cdbrew` | Go to `/opt/homebrew` |
| `shfig` | Open `~/.zshrc` in Neovim |
| `shload` | Reload `~/.zshrc` |
| `nvfig` | Open your Neovim config folder in Neovim |
| `g` | `git` |
| `ga` | `git add` |
| `gcam` | `git commit --all --message` (stage every tracked change and commit: `gcam "fix typo"`) |
| `dots` | Go to `~/dotfiles` |
| `dotfig` | Open `~/dotfiles` in Neovim |

`dud` shows disk usage one level deep, biggest first, then a total:

```zsh
dud              # current folder
dud ~/Downloads  # another folder
dud -a ~/dev     # sort by name instead of size
```

## Oh My Zsh plugins

In the order they load. All 11 live in `~/.oh-my-zsh/plugins/`.

### zsh-autosuggestions

As you type, it shows the rest of a matching past command in gray. Accept it with a key or keep typing to ignore it.

#### Commands

| Key | What it does |
| --- | --- |
| `→` or `Ctrl-F` | Accept the whole suggestion (cursor at the end of the line) |
| `End` or `Ctrl-E` | Accept the whole suggestion |
| `Ctrl-→` | Accept one word |
| Keep typing | Suggestion updates or disappears |

In Ghostty, Option-F usually accepts one word, but dirhistory has taken that key. To get a one-word key back, check that a key is free (`bindkey '<key>'` prints `undefined-key`), then add `bindkey '<key>' forward-word` after OMZ.

Widgets you can bind to keys yourself, after OMZ, with `bindkey '<key>' <widget>`:

| Widget | What it does |
| --- | --- |
| `autosuggest-accept` | Accept the suggestion |
| `autosuggest-execute` | Accept and run it |
| `autosuggest-clear` | Hide the current suggestion |
| `autosuggest-fetch` | Get a suggestion now, even when they're turned off |
| `autosuggest-disable` / `autosuggest-enable` | Turn suggestions off / on |
| `autosuggest-toggle` | Toggle them |

Example: `bindkey '^ ' autosuggest-accept` makes Ctrl-Space accept. This replaces Ctrl-Space's usual job of setting the mark that Option-W cuts to.

#### Settings

All go after OMZ.

| Setting | Default | What it does |
| --- | --- | --- |
| `ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE` | `fg=8` | Look of the suggestion. Color by name, 0–255 or `#hex`, plus `bg=`, `bold`, `underline`. Example: `'fg=#7a7a7a,underline'` |
| `ZSH_AUTOSUGGEST_STRATEGY` | `(history)` | Where suggestions come from, tried in order. `history`: most recent match. `completion`: what Tab would offer. `match_prev_cmd`: like history, but prefers what you ran after the same previous command (works poorly with Oh My Zsh's `hist_expire_dups_first`). Example: `(history completion)` |
| `ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE` | unset (no limit) | Stop suggesting once the line is this long. 20 is the suggested value; helps with big pastes |
| `ZSH_AUTOSUGGEST_HISTORY_IGNORE` | unset | Glob of history entries never to suggest, e.g. `"cd *"`, or `"?(#c50,)"` for anything 50+ characters |
| `ZSH_AUTOSUGGEST_COMPLETION_IGNORE` | unset | Glob of lines where the `completion` strategy is skipped, e.g. `"git *"` |
| `ZSH_AUTOSUGGEST_USE_ASYNC` | on | Fetch suggestions in the background. To turn off: `unset ZSH_AUTOSUGGEST_USE_ASYNC` |
| `ZSH_AUTOSUGGEST_MANUAL_REBIND` | unset | Set to anything to skip re-binding widgets before every prompt (faster). After changing the widget lists, run `_zsh_autosuggest_bind_widgets` |
| `ZSH_AUTOSUGGEST_ACCEPT_WIDGETS` | `forward-char end-of-line vi-forward-char vi-end-of-line vi-add-eol` | Widgets that accept the whole suggestion |
| `ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS` | `forward-word emacs-forward-word` and the vi word/find motions | Widgets that accept up to where the cursor lands |
| `ZSH_AUTOSUGGEST_EXECUTE_WIDGETS` | empty | Widgets that accept and run |
| `ZSH_AUTOSUGGEST_CLEAR_WIDGETS` | history search and up/down widgets, `accept-line`, `copy-earlier-word` | Widgets that clear the suggestion |
| `ZSH_AUTOSUGGEST_IGNORE_WIDGETS` | `orig-* beep run-help set-local-history which-command yank yank-pop zle-*` | Widgets that leave the suggestion alone |

Example:

```zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
```

### zsh-syntax-highlighting

Colors the command line as you type, so a typo or missing quote shows up before you press Enter. It adds no commands.

What the default colors mean:

| Looks like | Means |
| --- | --- |
| Green | A command, alias, function or builtin that exists |
| Bold red | Unknown command, or a syntax error |
| Underlined | A file or folder that exists |
| Green, underlined | `sudo`, `noglob` and similar, or a folder name you can cd into by typing it |
| Yellow | Quoted strings, `if` / `for` / `while`, redirections (`>`, `<`) |
| Cyan | `$var` inside double quotes, backslash escapes, global aliases like `...` |
| Blue | Globs (`*.txt`) and history references (`!!`) |
| Magenta | The `$(` `)` and backtick around a command substitution |
| Dim (bold black) | Comments |

#### Settings

All go after OMZ.

| Setting | Default | What it does |
| --- | --- | --- |
| `ZSH_HIGHLIGHT_HIGHLIGHTERS` | `(main)` | Which highlighters run. Add any of: `brackets` (color brackets by nesting, flag unmatched ones), `pattern` (your own patterns), `regexp` (your own regexes), `cursor` (the cursor position), `root` (whole line when you're root), `line` (whole line) |
| `ZSH_HIGHLIGHT_STYLES[<style>]` | see below | Change one style. Values: `fg=` and `bg=` (name, 0–255 or `#hex`), `bold`, `underline`, `standout`, `none`. Example: `ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'` |
| `ZSH_HIGHLIGHT_PATTERNS` | empty | Rules for the `pattern` highlighter, e.g. `ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')` |
| `ZSH_HIGHLIGHT_REGEXP` | empty | Rules for the `regexp` highlighter, e.g. `ZSH_HIGHLIGHT_REGEXP+=('^rm .*' 'fg=red,bold')`. On macOS, word boundaries are `[[:<:]]` and `[[:>:]]` |
| `ZSH_HIGHLIGHT_MAXLENGTH` | unset | Skip highlighting lines longer than this many characters |
| `ZSH_HIGHLIGHT_DIRS_BLACKLIST` | empty | Folders not to check for path highlighting (slow network drives) |

Style names you can set in `ZSH_HIGHLIGHT_STYLES`:

- main: `unknown-token`, `reserved-word`, `alias`, `suffix-alias`, `global-alias`, `builtin`, `function`, `command`, `precommand`, `commandseparator`, `hashed-command`, `autodirectory`, `path`, `path_prefix`, `path_pathseparator`, `path_prefix_pathseparator`, `globbing`, `history-expansion`, `command-substitution` (plus `-quoted`, `-unquoted`, `-delimiter`, `-delimiter-quoted`, `-delimiter-unquoted`), `process-substitution`, `process-substitution-delimiter`, `arithmetic-expansion`, `single-hyphen-option`, `double-hyphen-option`, `back-quoted-argument` (plus `-unclosed`, `-delimiter`), `single-quoted-argument` (plus `-unclosed`), `double-quoted-argument` (plus `-unclosed`), `dollar-quoted-argument` (plus `-unclosed`), `rc-quote`, `dollar-double-quoted-argument`, `back-double-quoted-argument`, `back-dollar-quoted-argument`, `assign`, `redirection`, `comment`, `named-fd`, `numeric-fd`, `arg0`, `default`
- brackets: `bracket-error`, `bracket-level-1`, `bracket-level-2`, ..., `cursor-matchingbracket`
- cursor: `cursor`; root: `root`; line: `line`

Example:

```zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[comment]='fg=244'
```

### zsh-interactive-cd

Pressing Tab after `cd` opens an fzf list of the matching folders one level down. Pick one and it fills in the path with a trailing `/`, so another Tab goes a level deeper.

#### Commands

| What you type | What happens |
| --- | --- |
| `cd ` then `Tab` | fzf list of the folders here |
| `cd src/` then `Tab` | Folders inside `src/` |
| `cd pro` then `Tab` | Folders starting with "pro"; if none, folders containing "pro" |
| `cd .` then `Tab` | Includes hidden folders (they're skipped otherwise) |

If only one folder matches, it's filled in without opening the list. In the list: type to filter, `Tab` / `Shift-Tab` move down / up, `Enter` picks, `Backspace` on an empty search closes it.

How it fits with fzf: fzf's Tab handler loads later and runs first. Without `**`, it hands Tab to this plugin, which hands everything except `cd` to normal completion. So `cd <Tab>` is this plugin and `cd **<Tab>` is fzf's recursive folder search.

#### Settings

| Setting | Default | What it does |
| --- | --- | --- |
| `zic_case_insensitive` | unset (case matters) | `true` ignores case when matching. Anywhere in `.zshrc` |
| `zic_custom_binding` | `'^I'` (Tab) | Use a different key for the picker. Before OMZ |
| `FZF_DEFAULT_OPTS`, `FZF_COMPLETION_OPTS` | unset | fzf options also used by this picker |
| `FZF_TMUX`, `FZF_TMUX_HEIGHT` | `0`, `40%` | Open in a tmux pane / list height |

### zsh-navigation-tools

Full-screen lists you can search and pick from: history, folders, processes, aliases, functions, environment variables and shell options. Move with arrows or `j`/`k`, `/` to search, `Enter` to pick, `q` to quit.

#### Commands

| Command | Short form | What it does |
| --- | --- | --- |
| `n-history` | `nhistory` | Search history with several words at once; Enter puts the command on your line. `F1` switches views, including a private history you can edit with `e` |
| `n-cd` | `ncd` | Pick from recent folders and bookmarked ones (the hotlist), then cd |
| `n-kill` | `nkill` | Process list like htop; pick a process, then a signal |
| `n-aliases` | `naliases` | Browse aliases and edit the one you pick |
| `n-functions` | `nfunctions` | Browse functions and edit with `zed` (your setting) |
| `n-env` | `nenv` | Browse environment variables and edit the one you pick |
| `n-options` | `noptions` | Browse shell options and toggle them |
| `n-panelize <command>` | `npanelize` | Any command's output as a searchable list: `n-panelize ls /usr/local/bin` or `ls \| n-panelize`. The line you pick lands on your prompt as a comment |
| `n-help` | `nhelp` | Full help for keys and settings |

Widgets for key bindings (after OMZ):

| Widget | Status | To bind it |
| --- | --- | --- |
| `znt-history-widget` | Bound to Ctrl-R by the plugin, then replaced by fzf | `bindkey '<key>' znt-history-widget` |
| `znt-cd-widget` | Not bound | `zle -N znt-cd-widget; bindkey '^B' znt-cd-widget` (replaces Ctrl-B, back one character) |
| `znt-kill-widget` | Not bound | `zle -N znt-kill-widget; bindkey '^Y' znt-kill-widget` (replaces Ctrl-Y, paste) |

Keys inside the lists:

| Key | What it does |
| --- | --- |
| `↑` `↓`, `k` `j`, `Ctrl-P` `Ctrl-N` | Move |
| `Ctrl-U` / `Ctrl-D` | Half a page up / down |
| `g` / `G` | Top / bottom |
| `←` `→`, `h` `l`, `<` `>`, `{` `}` | Scroll sideways |
| `/` | Search (several words allowed) |
| `F3` | Show or hide the search bar |
| `Esc` | Leave search and clear it |
| `Ctrl-W` / `Ctrl-K` | In search: delete a word / the whole query |
| `Ctrl-A` | Rotate the search words (1 2 3 becomes 3 1 2) |
| `Ctrl-F` or `f` | Fuzzy mode: allow 1–2 typos |
| `Ctrl-O` or `o` | Hide duplicate lines |
| `F2`, `Ctrl-X`, `Ctrl-/` | Cycle through saved search keywords |
| `[` / `]` | Jump between bookmarks (n-cd) or common signals (n-kill) |
| `Ctrl-T` / `Ctrl-G` | Next / previous color theme |
| `Ctrl-L` | Redraw |
| `F1` | Switch view (n-history) |
| `Ctrl-E` or `e` | Edit the private history (n-history, private view) |
| `H` or `?` | Help (n-history) |

#### Settings

Two ways to set these: edit `~/.config/znt/<tool>.conf`, or set the variable in `.zshrc` (anywhere; it wins over the file).

For all the tools (from `n-list.conf`):

| Setting | Yours | What it does |
| --- | --- | --- |
| `znt_list_bold` | `1` | Bold text (1) or not (0) |
| `znt_list_colorpair` | `green/black` | Text color / background |
| `znt_list_border` | `1` (set in `.zshrc`; the file says `0`) | Draw a border (1) or not (0) |
| `znt_list_themes` | 15 256-color themes | Colors cycled with Ctrl-T / Ctrl-G, written `fg/bg/bold`, e.g. `( "white/black/1" "green/black/0" )`. 256-color numbers work too |
| `znt_list_instant_select` | `0` | `1` makes Enter in search mode pick right away |

For each tool, replace `<tool>` with `history`, `cd`, `kill`, `aliases`, `functions`, `env`, `options` or `panelize`:

| Setting | Yours | What it does |
| --- | --- | --- |
| `znt_<tool>_active_text` | `underline` for history, `reverse` for the rest | How the selected row is shown |
| `znt_<tool>_nlist_coloring_pattern` | Differs per tool | Zsh pattern to color in each row |
| `znt_<tool>_nlist_coloring_color` | Yellow | Color for that pattern, e.g. `$'\x1b[00;34m'` for blue |
| `znt_<tool>_nlist_coloring_match_multiple` | Differs per tool | `1` colors every match in a row, `0` only the first |
| `znt_<tool>_keywords` | history: `git vim mplayer`; cd: `zsh local git`; kill: `vim git "git commit" firefox mplayer` | Saved searches cycled with F2 / Ctrl-X / Ctrl-/ |

Only for one tool:

| Setting | Yours | What it does |
| --- | --- | --- |
| `znt_cd_hotlist` | `~/.config/znt`, `/usr/share/zsh`, `/usr/local/share/zsh/site-functions`, `/usr/local/bin`, `/usr/lib` and a few more | Bookmarked folders in n-cd. These are Linux-style defaults; most don't exist on your Mac |
| `znt_cd_dont_pushd` | `0` | `1` stops n-cd from adding folders to the directory stack |
| `znt_functions_feditor` | `zed` | Editor for n-functions: `zed` or `vared` |

Example:

```zsh
znt_cd_hotlist=( ~/dev ~/Desktop/School ~/.config/nvim )
znt_history_keywords=( git nvim docker )
```

The plugin also turns on `AUTO_PUSHD`, `PUSHD_IGNORE_DUPS` and `HIST_IGNORE_DUPS`, which Oh My Zsh already sets.

### aliases

Adds `als`, a cheat sheet of every alias you have. Aliases are grouped by the command they run (`git`, `brew`, `docker-compose`, and so on). Commands with only one alias go in a group called `_default`.

#### Commands

| Command | What it does |
| --- | --- |
| `als` | Every alias, grouped |
| `als <text>` | Only aliases whose name or command contains that text, highlighted: `als push` |
| `als -g <group>` | One group: `als -g git`. Repeat `-g` for several |
| `als --groups` | Just the group names |
| `als -h` | Help |

#### Settings

None. It needs `python3`, which you have.

### brew

Short aliases for Homebrew. It also turns on Homebrew's own tab completion, exports `HOMEBREW_PREFIX`, and adds Homebrew's `sbin` folder to PATH if it's missing.

#### Commands

| Alias | What it's for | Runs |
| --- | --- | --- |
| `bi` | Install a formula | `brew install` |
| `bih` | Install a formula from its latest source | `brew install --HEAD` |
| `bcin` | Install an app (cask) | `brew install --cask` |
| `br` | Reinstall a formula | `brew reinstall` |
| `brh` | Reinstall from latest source | `brew reinstall --HEAD` |
| `bcrin` | Reinstall an app | `brew reinstall --cask` |
| `buz` | Uninstall an app and remove all its files | `brew uninstall --zap` |
| `ba` | Remove dependencies nothing needs anymore | `brew autoremove` |
| `bu` | Update Homebrew's list of packages | `brew update` |
| `bo` | List outdated formulae and casks | `brew outdated` |
| `bco` | List outdated apps | `brew outdated --cask` |
| `bubo` | Update the list, then show what's outdated | `brew update && brew outdated` |
| `bcubo` | Same, apps only | `brew update && brew outdated --cask` |
| `bup` | Upgrade everything not pinned | `brew upgrade` |
| `bfu` | Upgrade formulae only | `brew upgrade --formula` |
| `bcup` | Upgrade apps only | `brew upgrade --cask` |
| `bubu` | Update, show outdated, then upgrade | `bubo && bup` |
| `bugbc` | Upgrade everything, including apps that update themselves, then clean up | `brew upgrade --greedy && brew cleanup` |
| `bubug` | Update, show outdated, then `bugbc` | `bubo && bugbc` |
| `bcubc` | Upgrade apps, then clean up | `brew upgrade --cask && brew cleanup` |
| `bcn` | Delete old versions and caches | `brew cleanup` |
| `bl` | List installed formulae | `brew list` |
| `bcl` | List installed apps | `brew list --cask` |
| `brews` (function) | What you installed on purpose, with their dependencies, then apps | `brew leaves` + `brew deps --installed`, then `brew list --cask` |
| `bs` | Search formulae and apps | `brew search` |
| `bci` | Info about an app | `brew info --cask` |
| `brewp` | Pin a formula so upgrades skip it | `brew pin` |
| `brewsp` | List pinned formulae | `brew list --pinned` |
| `bdr` | Check for problems | `brew doctor` |
| `bcfg` | Show Homebrew and system info | `brew config` |
| `bsl` | List background services (Postgres, Redis...) | `brew services list` |
| `bson` | Start a service and run it at login | `brew services start` |
| `bsona` | Start all services | `bson --all` |
| `bsoff` | Stop a service and stop it running at login | `brew services stop` |
| `bsoffa` | Stop all services | `bsoff --all` |
| `bsr` | Run a service now without adding it to login | `brew services run` |
| `bsra` | Run all services now | `bsr --all` |

#### Settings

| Setting | Default | What it does |
| --- | --- | --- |
| `BREW_LOCATION` | unset | Path to `brew` if it's somewhere unusual. Only used when `brew` isn't already on PATH, which yours is. Before OMZ |

### colored-man-pages

Makes `man` pages easier to scan: headings and options in bold red, arguments and file names in green, the status line and search matches in yellow on blue.

#### Commands

| Command | What it does |
| --- | --- |
| `man <topic>` | Colored automatically |
| `colored <command>` | Color any other command that pages through `less` the same way: `colored git help clone` |

#### Settings

Change entries of the `less_termcap` array, after OMZ. Colors use zsh's `$fg_bold[...]`, `$fg[...]` and `$bg[...]` names (red, green, yellow, blue, magenta, cyan, white, black).

| Key | Default | Controls |
| --- | --- | --- |
| `less_termcap[md]` | bold red | Bold text: headings, option names |
| `less_termcap[mb]` | bold red | Blinking text (rare) |
| `less_termcap[us]` | bold green | Underlined text: arguments, file names |
| `less_termcap[so]` | bold yellow on blue | Standout: status line, search matches |
| `less_termcap[me]`, `[ue]`, `[se]` | reset | Where bold, underline and standout end. Leave these alone |

Example: `less_termcap[md]="${fg_bold[blue]}"` makes headings blue.

### colorize

`ccat` and `cless` work like `cat` and `less` but with syntax highlighting for 300+ languages, chosen from the file extension or, failing that, the contents. It uses `pygmentize` from your Python 3.13 install. If that Python is ever removed, `brew install chroma` and set `ZSH_COLORIZE_TOOL=chroma`.

#### Commands

| Command | What it does |
| --- | --- |
| `ccat <file>...` | Print files with highlighting. With no file, highlights what's piped in |
| `cless [less options] <file>...` | Open files in `less` with highlighting |

#### Settings

Anywhere in `.zshrc`.

| Setting | Default | What it does |
| --- | --- | --- |
| `ZSH_COLORIZE_TOOL` | `pygmentize` if found, else `chroma` | Which highlighter to use: `pygmentize` or `chroma` |
| `ZSH_COLORIZE_STYLE` | `emacs` | Color scheme, e.g. `monokai`, `dracula`, `github-dark`, `nord`. Full list: `pygmentize -L styles` |
| `ZSH_COLORIZE_CHROMA_FORMATTER` | `terminal` (8 colors) | chroma only: `terminal256` or `terminal16m` (true color) |

### dirhistory

Back and forward through the folders you've visited, like a browser, plus keys to go up a level or into the first subfolder. Each key wipes whatever you'd typed on the line, changes folder, and redraws the prompt.

#### Commands

| Key or command | What it does |
| --- | --- |
| `Option-←` or `Option-B` | Previous folder |
| `Option-→` or `Option-F` | Next folder (after going back) |
| `Option-↑` | Parent folder |
| `Option-↓` | First subfolder, alphabetically. Handy for deep Java package folders |
| `cde <dir>` | cd without clearing the "forward" list |

The history is kept in two arrays: `typeset -pm 'dirhistory_*'` shows them. This is separate from the directory stack that `d` and `1`–`9` use.

#### Settings

| Setting | Default | What it does |
| --- | --- | --- |
| `DIRHISTORY_SIZE` | `30` | How many folders to remember each way. After OMZ, since the plugin sets it when it loads |

Ghostty sends the same code for Option-← and Option-B (that's why dirhistory binds both), and likewise for Option-→ and Option-F. To get word movement back on those keys, add this after OMZ. Back and forward then have no key, but Option-↑ and Option-↓ still work:

```zsh
bindkey '^[b' backward-word
bindkey '^[f' forward-word
```

### docker-compose

Short aliases for Docker Compose. Because Docker Desktop installed `~/.docker/bin/docker-compose`, the aliases call `docker-compose`. Without it they'd call `docker compose`; the two behave the same.

#### Commands

| Alias | What it's for | Runs |
| --- | --- | --- |
| `dco` | Compose itself: `dco ls` | `docker-compose` |
| `dcup` | Build if needed, create and start everything, show logs | `docker-compose up` |
| `dcupd` | Same, in the background | `docker-compose up -d` |
| `dcupb` | Rebuild images first, then start | `docker-compose up --build` |
| `dcupdb` | Rebuild, then start in the background | `docker-compose up -d --build` |
| `dcupw` | Start and rebuild/restart when files change | `docker-compose up --watch` |
| `dcupwb` | Same, rebuilding first | `docker-compose up --watch --build` |
| `dcdn` | Stop and remove the containers | `docker-compose down` |
| `dcstop` | Stop without removing | `docker-compose stop` |
| `dcstart` | Start stopped containers | `docker-compose start` |
| `dcrestart` | Restart | `docker-compose restart` |
| `dck` | Kill containers right away | `docker-compose kill` |
| `dcrm` | Remove stopped containers | `docker-compose rm` |
| `dcps` | List containers | `docker-compose ps` |
| `dcl` | Show logs | `docker-compose logs` |
| `dclf` | Show logs and keep following | `docker-compose logs -f` |
| `dclF` | Follow new log lines only | `docker-compose logs -f --tail 0` |
| `dce` | Run a command in a running container: `dce db psql -U test` | `docker-compose exec` |
| `dcr` | Run a one-off command in a new container | `docker-compose run` |
| `dcb` | Build images | `docker-compose build` |
| `dcpull` | Pull newer images | `docker-compose pull` |
| `dci` | List images used | `docker-compose images` |
| `dcsts` | Live CPU and memory use | `docker-compose stats` |
| `dcc` | Print the final merged compose file | `docker-compose config` |
| `dcv` | Version | `docker-compose version` |

#### Settings

None.

## Shell tools loaded outside Oh My Zsh

### fzf

A general-purpose fuzzy finder (version 0.74.5). `source <(fzf --zsh)` in your `.zshrc` loads its key bindings and its `**` completion.

#### Commands

| Key or command | What it does |
| --- | --- |
| `Ctrl-T` | Pick files and folders below here (Tab marks several); pastes their paths |
| `Ctrl-R` | Search history. In the list, `Ctrl-R` switches between newest-first and best-match, `Option-R` shows raw lines, `Tab` marks several commands |
| `Option-C` | Pick a folder below here and cd into it |
| `<command> **` then `Tab` | Pick files and folders below here for any command: `nvim **<Tab>` |
| `cd **` then `Tab` | Folders only (same for `pushd` and `rmdir`) |
| `ssh **` / `telnet **` then `Tab` | Hosts from `~/.ssh/config`, `known_hosts` and `/etc/hosts` |
| `kill **` then `Tab` | Processes. Tab marks several; click a column header to search that column |
| `export **` / `unset **` then `Tab` | Environment variable names |
| `unalias **` then `Tab` | Alias names |
| `fzf` | Pick from the files below here and print the choice: `nvim "$(fzf)"` |
| `<command> \| fzf` | Pick a line from any output: `git branch \| fzf` |

In any fzf list: type to filter, `Ctrl-J` / `Ctrl-K` or arrows to move, `Tab` to mark, `Enter` to pick, `Esc` to cancel.
Search syntax: `word` fuzzy, `'word` exact, `^word` starts with, `word$` ends with, `!word` excludes, `a | b` either.

#### Settings

Put these above the `source <(fzf --zsh)` line.

| Setting | Default | What it does |
| --- | --- | --- |
| `FZF_DEFAULT_OPTS` | unset | Options for every fzf list, e.g. `'--height 50% --layout reverse --border'` |
| `FZF_DEFAULT_OPTS_FILE` | unset | A file holding those options instead |
| `FZF_DEFAULT_COMMAND` | unset (fzf walks the folder itself) | What plain `fzf` lists, e.g. `'fd --type f --hidden --exclude .git'` |
| `FZF_CTRL_T_COMMAND` | unset (fzf's walker, includes hidden files) | What Ctrl-T lists. Set to `""` to turn Ctrl-T off |
| `FZF_CTRL_T_OPTS` | unset | Extra options for Ctrl-T, e.g. `"--preview 'cat {}'"` |
| `FZF_CTRL_R_OPTS` | unset | Extra options for Ctrl-R |
| `FZF_CTRL_R_COMMAND` | unset | Set to `""` to turn Ctrl-R off (custom commands aren't supported) |
| `FZF_ALT_C_COMMAND` | unset (fzf's walker) | What Option-C lists. `""` turns it off |
| `FZF_ALT_C_OPTS` | unset | Extra options for Option-C, e.g. `"--preview 'ls {}'"` |
| `FZF_COMPLETION_TRIGGER` | `**` | What triggers fzf completion before Tab |
| `FZF_COMPLETION_OPTS` | unset | Extra options for `**` completion (zsh-interactive-cd uses these too) |
| `FZF_COMPLETION_PATH_OPTS` / `FZF_COMPLETION_DIR_OPTS` | unset | Extra options for file / folder completion only |
| `FZF_COMPLETION_DIR_COMMANDS` | `cd pushd rmdir` | Commands whose `**` lists folders only |
| `FZF_TMUX` / `FZF_TMUX_OPTS` / `FZF_TMUX_HEIGHT` | `0` / unset / `40%` | Open lists in a tmux pane; list height |

Functions you can define to change behavior further: `_fzf_compgen_path` and `_fzf_compgen_dir` (what `**` lists), `_fzf_comprun` (different options per command), `_fzf_complete_<command>` (your own `**` completion for a command), `__fzf_list_hosts` (host list for ssh).

### zoxide

zoxide is set up with `--cmd cd`, so it replaces `cd` itself: `cd foo` jumps to a folder from a piece of its name, picking the one you use most often and most recently, while `cd` with a real path works as usual. Every folder you visit is added to its list. The interactive picker is `cdi`. (The upstream docs call these `z` and `zi`; those names don't exist in your shell.)

#### Commands

| Command | What it does |
| --- | --- |
| `cd foo` | Go to the best match for "foo" |
| `cd foo bar` | Best match containing "foo" then "bar" |
| `cd ~/path`, `cd ..`, `cd dir/` | Works like plain `cd` for real paths |
| `cd -` | Previous folder |
| `cdi foo` | Pick from the matches with fzf |
| `cd foo` then `Space` `Tab` | Pick from the matches as completions |
| `zoxide query foo` | Print the best match without going there |
| `zoxide query -l` / `-ls` | List all remembered folders / with scores |
| `zoxide query -i` | Pick interactively and print it |
| `zoxide query --exclude <path>` / `--all` | Leave a path out / include folders that were deleted |
| `zoxide add <path>` | Add a folder or bump its score |
| `zoxide remove <path>` | Forget a folder |
| `zoxide import <file> --from z` (or `autojump`) | Bring in data from another jumper. Add `--merge` if you already have data |

How ranking works: each visit adds 1 to a folder's score. When you search, the score counts ×4 if you visited in the last hour, ×2 in the last day, ÷2 in the last week, ÷4 if older.

#### Settings

Environment variables, set above the `eval "$(zoxide init zsh --cmd cd)"` line:

| Setting | Default | What it does |
| --- | --- | --- |
| `_ZO_DATA_DIR` | `~/Library/Application Support` | Where the database is kept |
| `_ZO_ECHO` | unset | `1` prints the folder before jumping |
| `_ZO_EXCLUDE_DIRS` | `$HOME` | Folders never added, as colon-separated globs: `"$HOME:$HOME/Library/*"` |
| `_ZO_FZF_OPTS` | unset | fzf options for `cdi` |
| `_ZO_MAXAGE` | `10000` | Cap on the total score; old, rarely used folders drop off past it |
| `_ZO_RESOLVE_SYMLINKS` | unset | `1` stores real paths instead of symlinks |

Options for the `zoxide init zsh` line itself:

| Option | What it does |
| --- | --- |
| `--cmd <name>` | Rename the commands: `--cmd j` gives `j` and `ji`; `--cmd cd` (yours) replaces `cd` itself and gives `cdi` |
| `--hook none` / `prompt` / `pwd` | When folders get scored: never, at every prompt, or on every cd (default) |
| `--no-cmd` | Don't create `z` and `zi` (they stay available as `__zoxide_z` and `__zoxide_zi`) |

## Prompt theme: modern-dark-pro-capsule

The prompt is a row of "capsules" on the first line and `❯` on the second. `❯` is green after a command succeeds, red after one fails, and becomes `#` when you're root. The clock sits on the right.

What the capsules show, left to right. Each appears only when it applies:

| Capsule | Shows |
| --- | --- |
| SSH | `user@host` when you're connected over SSH |
| Folder | The last 6 folders of the path, plus a lock if you can't write here. Cmd-click opens it in Finder |
| Git branch | Branch name, commits ahead / behind, and REBASING 2/5, MERGING, CHERRY-PICKING, BISECTING or REVERTING. Cmd-click opens the branch on GitHub |
| Git changes | Changed files • +lines −lines. When only untracked files changed, `?n` shows how many |
| Python | The active virtualenv or conda env |
| Node, Go, Rust, Terraform | The version, when the folder has `package.json`, `go.mod` or `.go` files, `Cargo.toml`, or `.tf` files |
| Kubernetes | Current kubectl context |
| AWS | `AWS_PROFILE@region` |
| Jobs | Number of background jobs |
| Timer | How long the last command took, if 2 seconds or more |

#### Settings

All start with `MODERN_DARK_PRO_` and go before OMZ. "Yours" is what's in effect now.

| Setting | Default | Yours | Options |
| --- | --- | --- | --- |
| `VARIANT` | `night` | `night` | `night` (soft pastels) or `monokai` |
| `PILL_STYLE` | `bracket` | `bracket` | `bracket` (`[ … ]`), `round` (filled powerline pills) or `none` |
| `PILL_COLOR_STYLE` | `solid` | `solid` | Round pills only: `solid` (colored pill, dark text) or `dark` (dark gray pill, colored text) |
| `PILL_TEXT_COLOR` | `#111111` | default | Text color inside solid round pills |
| `PROMPT_LAYOUT` | `two-line` | `two-line` | `single`, `two-line` or `classic` (adds `┌─` `└─` guide lines) |
| `SHOW_CLOCK` | `true` | `true` | `false` hides the clock in `single`, and the top clock in `two-line`. It doesn't hide an `rprompt` clock in `two-line`, and `classic` always shows the clock |
| `CLOCK_POSITION` | `top` | `rprompt` | `top` (end of the first line) or `rprompt` (right side of the input line) |
| `PATH_STYLE` | `limit` | `limit` | `limit` (last N folders), `shrink` (first letter of each folder: `~/d/docs`), anything else shows the full path |
| `PATH_DEPTH` | `3` | `6` | N for `limit` |
| `NERD_FONTS` | `true` | `true` | `true` for icons, `false` for plain symbols and emoji |
| `SHOW_EXEC_TIME` | `true` | default | Show the timer capsule |
| `EXEC_TIME_MIN` | `2` | default | Seconds a command must take before the timer shows |
| `CHAR` | `❯` | default | The prompt character |
| `BORDER_COLOR` | dark gray | default | Bracket color |
| `CLICKABLE_PATH` | `true` | `true` | Cmd-click the folder (off over SSH) |
| `CLICKABLE_GIT` | `true` | `true` | Cmd-click the branch (off over SSH) |
| `<NAME>_SYMBOL` | icons | default | Replace any icon. Names: `DIR`, `GIT`, `CHANGES`, `TIME`, `AHEAD`, `BEHIND`, `LOCK`, `SSH`, `JOBS`, `PYTHON`, `NODE`, `GO`, `RUST`, `TF`, `K8S`, `AWS`. Example: `export MODERN_DARK_PRO_GIT_SYMBOL="⎇"` |

The theme also sets the colors `ls` and tab completion use (`CLICOLOR`, `LSCOLORS`, `LS_COLORS`). Ghostty supports true color, so the theme uses its hex colors rather than the 256-color fallbacks.

To change these, edit the `export MODERN_DARK_PRO_...` lines in `.zshrc`. Or run the setup wizard, which asks 7 questions:

```zsh
bash ~/dotfiles/zsh/modern-dark-pro-capsule/wizard.sh
```

The wizard saves a `.zshrc.bak.<date>` copy each time and adds a new block above `source $ZSH/oh-my-zsh.sh`. It doesn't remove the old block (see [Problems](#problems-in-the-current-setup)), so delete the old one by hand afterwards.

## Oh My Zsh itself

The framework the plugins run on. It adds its own commands and turns on a set of shell behaviors.

#### Commands

| Command | What it does |
| --- | --- |
| `omz update` | Update Oh My Zsh |
| `omz reload` | Restart the shell cleanly. Better than `source ~/.zshrc` after big changes |
| `omz plugin list` / `omz plugin list --enabled` | All plugins / yours |
| `omz plugin info <name>` | Show a plugin's README |
| `omz plugin enable <name>` / `disable <name>` | Add / remove a plugin in your `.zshrc` |
| `omz plugin load <name>` | Load a plugin for this session only |
| `omz theme list` / `omz theme use <name>` / `omz theme set <name>` | List themes / try one for this session / save one to `.zshrc` |
| `omz version`, `omz changelog`, `omz help` | Version, what's new, help |
| `omz shellsaver [aquarium \| logo \| hermit \| party]` | A terminal screensaver |
| `take <dir>` | `mkdir -p` and cd into it. Given a `.tar.gz` or `.zip` URL: download, extract, cd in. Given a `.git` URL: clone and cd in |
| `mkcd <dir>`, `takedir <dir>` | Same as `take` for a folder |
| `..` | Up one folder (any folder name typed alone cds into it) |
| `...`, `....`, `.....`, `......` | `../..`, `../../..` and so on. These expand anywhere in a command, so `cp f ...` copies two levels up |
| `-` | Previous folder |
| `d` | Your last 10 folders, numbered |
| `1` to `9` | Jump to that folder from the `d` list |
| `md` / `rd` | `mkdir -p` / `rmdir` |
| `l` or `lsa` / `ll` / `la` | `ls -lah` / `ls -lh` / `ls -lAh` |
| `_ <command>` | Run with `sudo` |
| `history` | Your full history. `history -c` deletes it after asking |
| `zsh_stats` | Your 20 most-used commands |
| `clipcopy` / `clippaste` | Copy to / paste from the clipboard: `cat key.pub \| clipcopy` |
| `open_command <path or URL>` | Open with the default app |

`grep` is set to color its output and skip `.git`, `.svn`, `.hg`, `.bzr`, `CVS`, `.idea`, `.tox`, `.venv` and `venv` folders. `diff` gets `--color` if your version supports it.

#### Behaviors that are on

- Typing a folder name alone cds into it.
- Every cd is added to the folder list that `d` and `1`–`9` use, without duplicates.
- History: 50,000 commands in memory, 10,000 saved in `~/.zsh_history`, shared live between tabs. Repeats in a row aren't saved twice. Start a command with a space to keep it out of history. Commands using `!!` are shown for a check before they run.
- Tab completion ignores case, matches in the middle of words, and opens an arrow-key menu on the second Tab.
- `#` starts a comment at the prompt.
- Auto-correction (you turned it on): zsh offers to fix typos in commands and in arguments. Answer `n` to keep yours, `y` to accept, `a` to cancel, `e` to edit. `cp`, `mv`, `mkdir`, `man`, `sudo` and `su` are never corrected. Put `nocorrect` before any other command to skip it once.

#### Settings

Set near the top of `.zshrc`, before OMZ.

| Setting | Default | Yours | What it does |
| --- | --- | --- | --- |
| `ENABLE_CORRECTION` | off | `true` | Auto-correction, described above |
| `CASE_SENSITIVE` | off | off | `true` makes completion case-sensitive |
| `HYPHEN_INSENSITIVE` | off | off | `true` lets `-` and `_` match each other in completion |
| `COMPLETION_WAITING_DOTS` | off | `true` | `true` (or your own text) shows dots while completion is working |
| `DISABLE_MAGIC_FUNCTIONS` | off | off | `true` if pasted URLs or text get mangled |
| `DISABLE_LS_COLORS` | off | off | `true` turns off colors in `ls` |
| `DISABLE_AUTO_TITLE` | off | off | `true` stops Oh My Zsh from setting the tab title |
| `DISABLE_UNTRACKED_FILES_DIRTY` | off | off | Faster git status in big repos, for themes using Oh My Zsh's git prompt (yours doesn't) |
| `HIST_STAMPS` | unset | unset | Date format for `history`: `"mm/dd/yyyy"`, `"dd.mm.yyyy"`, `"yyyy-mm-dd"` or a strftime format |
| `ZSH_CUSTOM` | `~/.oh-my-zsh/custom` | default | Where your own plugins and themes go |
| `zstyle ':omz:update' mode <mode>` | `prompt` | default | `prompt` (ask), `auto`, `reminder`, `background-alpha` (update in the background) or `disabled` |
| `zstyle ':omz:update' frequency <days>` | `13` | default | Days between update checks |
| `zstyle ':omz:update' cooldown <days>` | unset | default | How old an update must be before it's applied |
| `zstyle ':omz:lib:theme-and-appearance' gnu-ls yes` | off | off | Use GNU `ls` (`gls`) if it's installed |
| `zstyle ':omz:alpha:lib:git' async-prompt <yes/no>` | automatic | default | Only matters for themes using Oh My Zsh's git prompt. Yours doesn't |

## PATH

Searched top to bottom. `which -a <command>` shows every copy of a command and which one wins.

| Folder | Added in | What's there |
| --- | --- | --- |
| `~/.bun/bin` | `.zshrc` | bun |
| Python 3.13 framework `bin` | `.zprofile` | `python3`, `pip3`, `pygmentize` from python.org (ahead of Homebrew's) |
| `/opt/homebrew/bin`, `/opt/homebrew/sbin` | `.zprofile` (`brew shellenv`) | Homebrew tools |
| `/usr/local/bin`, `/usr/bin`, `/bin`, ... | macOS | System tools, including Apple's `git` |
| `~/.docker/bin` | `.zprofile` | Docker Desktop: `docker`, `docker-compose`, `kubectl` |
| JetBrains Toolbox `scripts` | `.zprofile` | IDE launchers |
| `~/.local/bin` | `.zprofile` | `claude`, `uv`, pipx tools |

## Other CLI tools

| Tool | What it's for | Commands to remember |
| --- | --- | --- |
| eza (0.23) | Modern `ls` behind `lls`. Note `-h` means header row, not human sizes (sizes are human by default) | `eza -l`, `eza -T -L 2` tree, `eza -l -s modified` sort by date (`-r` reverses), `eza --git -l` git status column |
| ripgrep (`rg`) | Fast text search (also powers grep in Neovim) | `rg "text"`, `rg -i` ignore case, `rg -l` file names only, `rg -t py foo` Python files only |
| fd | Fast file finder (also powers file search in Neovim) | `fd name`, `fd -e lua` by extension, `fd -H` include hidden |
| trash | Moves files to the macOS Trash (built into macOS) | `trash file` instead of `rm file` |
| Docker | Containers (the docker-compose plugin uses it) | `docker ps`, `docker logs -f <name>` |
| uv | Python projects and virtualenvs | `uv venv`, `uv add <pkg>`, `uv run script.py` |
| bun | JavaScript runtime and package manager | `bun install`, `bun run dev`, `bunx <tool>` |
| claude | Claude Code CLI (2.1.x) | `claude`, `claude -c`, `claude -r`. Full sheet: [CLAUDE-CODE.md](CLAUDE-CODE.md) |
| lazygit | Terminal git UI (also `<leader>gg` in Neovim) | `lazygit` in a repo |

## Change log

- 2026-11-13: `lls` is now the `lls_depth` function: takes paths like `ls` plus an optional depth (`-L N`, `--level=N` or a bare number, 1–5), always shows total folder sizes; `llsd` removed. Renamed `cdd` → `desk`, `zfig` → `shfig`, `zload` → `shload`; removed `cds`. zoxide now runs with `--cmd cd` (`cd` jumps, `cdi` picks). Turned on `COMPLETION_WAITING_DOTS`. znt lists: bold, green, border on, 256-color themes.

- 2026-11-13: Removed the Oh My Zsh `git` plugin (201 aliases, of which only `g`, `ga`, `gcam` appeared in history). Those three are now your own aliases in `.zshrc`; git's tab completion is built into zsh and unaffected. Shell aliases: 318 → 116.

- 2026-11-13: Removed stale aliases `cddev` (`~/Developer` is gone), `testdb` and `gendocs` (Senior Design). Hid the git plugin's `gg`, `gga`, `gk`, `gke` with `unalias`. Listing aliases are now `lls` (tree, 1 level) and `llsd` (2 levels, total sizes).

- 2026-11-13: `.zshrc` cleanup: one theme block instead of three (same values; clock stays on the right), `zsh-syntax-highlighting` moved to the end of `plugins=(...)`, removed the no-op `async-prompt` zstyle. Installed lazygit.

- 2026-11-13: Re-checked against `~/.zshrc`. `lls` now uses eza; added `dlls`, `llst`, `dllst`. `~/Developer` exists again, so `cddev` works. The three theme blocks are still there (the last one wins: clock on the right). Added eza to Other CLI tools. No config files changed.

- 2026-11-05: Rewrote this manual with a section per plugin, covering the 8 plugins added on Nov 4. No config files changed.
- 2026-11-04: 8 plugins added (zsh-interactive-cd, zsh-navigation-tools, aliases, brew, colored-man-pages, colorize, dirhistory, docker-compose). The theme wizard ran twice, which moved the clock to the right and added two theme blocks.
- 2026-11-03: Config cleanup. Details and original files are in `~/dotfiles/archive/2026-11-03/`.
