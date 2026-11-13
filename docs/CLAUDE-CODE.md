# Claude Code Reference

Kenneth's Claude Code setup as of 2026-11-13: Claude Code 2.1.323 (native install in `~/.local/bin`), ECC 2.2.3 (installed as plain files, trimmed to your stack) with its hooks on, vim input mode, auto permission mode, running fullscreen in Ghostty.
Companion sheets: [ZSH.md](ZSH.md), [NEOVIM.md](NEOVIM.md).

Quick lookups:

- `/help` lists commands. Type `/` and keep typing to filter every command and skill.
- `/config` (or `/settings`) changes settings in a menu. `/doctor` checks the install.
- `/ecc-guide` maps the ECC plugin's agents, skills, commands and hooks.
- `claude --help` lists every CLI flag.

## Contents

1. [Config files](#config-files)
2. [Your settings](#your-settings)
3. [Starting Claude from the shell](#starting-claude-from-the-shell)
4. [Keys in a session](#keys-in-a-session)
5. [Built-in slash commands](#built-in-slash-commands)
6. [ECC](#ecc)
7. [Skills](#skills)
8. [MCP servers and connectors](#mcp-servers-and-connectors)
9. [Claude Code in Neovim](#claude-code-in-neovim)
10. [Problems and to-dos](#problems-and-to-dos)

## Config files

> All of these files now live in `~/dotfiles` (symlinked into place). See `~/dotfiles/README.md`.

| File | What it controls |
| --- | --- |
| `~/.claude/settings.json` | Your user settings: permissions, plugins, model effort, UI, skill on/off switches |
| `~/.claude/settings.json.bak-doctor-20261113` | Backup from before the `skillOverrides` and synced-plugin entries were added on Nov 13 |
| `~/.claude.json` | App state Claude manages itself: login, per-project history, MCP servers added with `claude mcp add`, `autoUpdates` |
| `~/.claude/skills/` | Your user-level skills (21, all switched off, see [Skills](#skills)) plus `synced/` skills from claude.ai |
| `~/.claude/plugins/` | Installed plugins and marketplaces. `installed_plugins.json` lists what's installed |
| `~/.claude/{agents,commands,rules/ecc,hooks,scripts}/`, `~/.claude/ecc/install-state.json` | ECC, installed as plain user-level files (see [ECC](#ecc)) |
| `~/.claude/projects/<path>/memory/` | Auto-memory Claude keeps per project. `MEMORY.md` there is the index |
| `~/.claude/history.jsonl` | Your prompt history (what `↑` and `Ctrl-R` search) |
| `~/.claude/session-data/` | Saved sessions from ECC's `/save-session` (resume with `/resume-session`) |
| `~/.claude/cost-tracker.log`, `metrics/` | ECC's cost tracking (`/cost-report` reads these) |
| `CLAUDE.md` in a project | Project instructions, loaded automatically. You have no global `~/.claude/CLAUDE.md` |
| `.claude/settings.json` in a project | Per-project settings (shared). `.claude/settings.local.json` is personal and git-ignored |

Settings load in this order, later ones winning: user → project → project local → command-line flags.

## Your settings

From `~/.claude/settings.json` and `~/.claude.json`:

| Setting | Yours | What it means |
| --- | --- | --- |
| `permissions.defaultMode` | `auto` | Claude runs most tools without asking; risky or outward-facing actions still prompt. `Shift-Tab` cycles modes in a session |
| `modelSettings.claude-opus-5-5.effortLevel` | `medium` | Default thinking effort for Opus. Override per session with `/model` or `claude --effort high` |
| `editorMode` | `vim` | The prompt box has vim normal/insert modes (see [Keys](#keys-in-a-session)) |
| `tui` | `fullscreen` | Full-screen terminal UI |
| `theme` | `auto` | Follows the macOS light/dark setting |
| `includeCoAuthoredBy` | `false` | No "Co-Authored-By: Claude" line in commits |
| `remoteControlAtStartup` | `true` | Every session can be followed from claude.ai or the phone app |
| `agentPushNotifEnabled`, `inputNeededNotifEnabled` | `true` | Push notifications when a background agent finishes or a session needs you |
| `env.GATEGUARD_BASH_ROUTINE_DISABLED` | `1` | Turns off ECC GateGuard's checks on routine shell commands (the edit checks stay on) |
| `enabledPlugins` | `daloopa`, `data`, `engineering` (synced from claude.ai) all off. ECC is no longer a plugin | See [ECC](#ecc) |
| `hooks` | ECC's hooks, written by its installer | Profile via `ECC_HOOK_PROFILE` (default `standard`) |
| `skillOverrides` | 60 ECC commands `off`, 25 `name-only` | `off`: unused languages, missing dependencies, niche tooling. `name-only`: commands you type yourself, listed without a description so the skill list fits Claude's budget. See [ECC](#ecc) |
| `autoUpdates` (`~/.claude.json`) | `false` | Claude Code doesn't update itself. Run `claude update` |

Change most of these with `/config`. For permissions, hooks and env vars, ask Claude to use the `update-config` skill, or edit the JSON directly.

## Starting Claude from the shell

| Command | What it does |
| --- | --- |
| `claude` | Start a session in this folder |
| `claude "fix the failing test"` | Start with a first prompt |
| `claude -c` | Continue the most recent session in this folder |
| `claude -r` | Pick an earlier session to resume. `claude -r <id>` resumes one directly |
| `claude -c --fork-session` | Resume as a copy, leaving the original alone |
| `claude --from-pr 42` | Resume the session linked to a PR |
| `claude -p "question"` | Print one answer and exit (scriptable). Add `--output-format json` for JSON |
| `cat log.txt \| claude -p "what failed?"` | Pipe input in |
| `claude --model sonnet` / `--effort high` | Pick the model / effort for this session |
| `claude --permission-mode plan` | Start in plan mode (reads only, proposes a plan) |
| `claude --add-dir ../other-repo` | Let Claude work in another folder too |
| `claude -n "name"` | Name the session |
| `claude --bg "task"` | Start in the background. `claude agents` lists them, `claude attach <id>` opens one, `claude logs <id>`, `claude stop <id>`, `claude rm <id>` |
| `claude --cloud "task"` | Run it as a cloud session on claude.ai |
| `claude --safe-mode` | Start with all customizations off (plugins, hooks, skills): good for "is ECC causing this?" |
| `claude --bare` | Minimal mode: no hooks, plugins, CLAUDE.md or auto-memory |
| `claude --chrome` | Turn on Claude in Chrome for browser tasks |
| `claude --debug hooks` | Debug log for one area (e.g. `hooks`, `mcp`) |

Subcommands:

| Command | What it does |
| --- | --- |
| `claude update` | Update Claude Code (auto-updates are off) |
| `claude doctor` | Health check |
| `claude plugin ...` | `list`, `install <name>@<marketplace>`, `enable`, `disable`, `uninstall`, `marketplace add <url>` |
| `claude mcp ...` | `list`, `add <name> -- <command>`, `remove <name>`, `get <name>` |
| `claude auth` / `claude setup-token` | Log in or out / make a long-lived token |
| `claude auto-mode` | Inspect or reset what auto mode allows |
| `claude purge [path]` | Delete Claude's stored data for a project |
| `claude ultrareview` | Cloud multi-agent review of the current branch (billed) |

## Keys in a session

| Keys | What it does |
| --- | --- |
| `Enter` | Send |
| `Shift-Enter` | New line (set up by `/terminal-setup`, which you've run). `\` then `Enter` works anywhere |
| `Esc` | Stop Claude mid-answer. With vim mode on, also leaves insert mode |
| `Esc` `Esc` | Rewind: pick an earlier message to go back to (code and/or conversation). Same as `/rewind` |
| `Shift-Tab` | Cycle permission mode: default → accept edits → plan → auto |
| `Ctrl-C` | Cancel the current input; twice to quit |
| `Ctrl-D` | Quit |
| `↑` / `↓` | Previous / next prompt |
| `Ctrl-R` | Search prompt history |
| `Ctrl-O` | Show the full transcript (tool calls and output) |
| `Ctrl-T` | Show the task list |
| `Ctrl-B` | Send the running shell command or agent to the background |
| `Ctrl-G` | Write the prompt in Neovim (your `$EDITOR`) |
| `Ctrl-V` | Paste an image from the clipboard |
| `Ctrl-L` | Clear the screen (keeps the conversation) |
| `Option-P` / `Option-T` | Switch model / toggle extended thinking |
| `@path` | Mention a file or folder; Tab completes the path |
| `!command` | Run a shell command yourself; output goes into the conversation |
| `/` | Commands and skills menu |

Vim mode in the prompt box: `Esc` for normal mode, then `h j k l`, `w b e`, `0 $`, `gg G`, `x`, `dd`, `dw`, `cw`, `ciw`, `D`, `C`, `p`, `u`, `.`, and `i a I A o O` back to insert. Turn it off with `/vim`.

Change keys with `~/.claude/keybindings.json` (you have none yet). Ask Claude to use the `keybindings-help` skill.

## Built-in slash commands

| Command | What it does |
| --- | --- |
| `/help` | All commands |
| `/clear` | Start a fresh conversation |
| `/compact [focus]` | Summarize the conversation to free up context. Add what to keep: `/compact keep the API design` |
| `/context` | What's using the context window |
| `/rewind` | Go back to an earlier point (also `Esc Esc`) |
| `/resume` | Switch to another session |
| `/model` | Change model and effort |
| `/config`, `/settings` | Settings menu |
| `/permissions` | View and edit allow/deny rules |
| `/memory` | Edit CLAUDE.md files and auto-memory |
| `/init` | Write a CLAUDE.md for the current project |
| `/plugin` | Browse, install and enable plugins |
| `/mcp` | MCP server status, log into connectors |
| `/agents` | Manage subagents |
| `/hooks` | See the hooks that are active |
| `/usage` | Plan usage and limits. `/cost` for this session's cost |
| `/doctor` | Check the install and settings |
| `/terminal-setup` | Set up Shift-Enter in the terminal |
| `/vim` | Toggle vim mode |
| `/artifacts` | Your published artifacts (`o` open, `c` copy link) |
| `/code-review [level]` | Review the current diff for bugs. `--fix` applies fixes, `--comment` posts to the PR |
| `/simplify` | Clean up the changed code (reuse, simplification) |
| `/security-review` | Security pass over pending changes |
| `/loop [interval] <prompt>` | Repeat a prompt on an interval, or self-paced |
| `/schedule` | Cloud agents that run on a schedule |
| `/login`, `/logout` | Switch account |
| `/exit` | Quit |

## ECC

ECC ("Everything Claude Code", `affaan-m/ECC`) is installed as ordinary files in `~/.claude`, not as a plugin, so every piece can be switched on or off on its own. Commands show as plain `/name`.

| What | Where | Count |
| --- | --- | --- |
| Skills (your stack plus core workflow) | `~/.claude/skills/` | 43 |
| Agents | `~/.claude/agents/` | 30 |
| Slash commands | `~/.claude/commands/` | 98 installed: 60 `off`, 25 `name-only` (still work when typed) in `skillOverrides` |
| Rules (coding style, testing, git, security) | `~/.claude/rules/ecc/` | `common` loads every session; `python`, `typescript`, `java`, `react`, `web` load only for matching files |
| Hooks | `settings.json` → `hooks`, scripts in `~/.claude/scripts/` and `~/.claude/hooks/` | 8 events |

Skills: Python, Django (+ Celery, security, TDD, verification), FastAPI, Spring Boot (+ security, TDD, verification), JPA, Java standards, Postgres, migrations, Docker, deployment, React (+ testing, performance), TypeScript, Vite, frontend/backend/API design, E2E, TDD, verification loop, security review, coding standards, git workflow, GitHub ops, codebase onboarding, search-first, error handling, docs lookup, ML workflow, `ecc-guide`, `orch-add-feature` / `orch-fix-defect` / `orch-change-feature` / `orch-refine-code`.

Agents: planner, architect, code-reviewer, security-reviewer, tdd-guide, build-error-resolver, e2e-runner, refactor-cleaner, doc-updater, mle-reviewer, python/django/fastapi/java/typescript/react/database reviewers, django/java/react build resolvers, code-explorer, code-architect, code-simplifier, silent-failure-hunter, pr-test-analyzer, comment-analyzer, type-design-analyzer, commit-reviewer, docs-lookup, performance-optimizer.

| File | What it's for |
| --- | --- |
| `~/dotfiles/vendor/ECC/` | ECC source (git clone) |
| `~/dotfiles/claude/ecc/ecc-skills.txt` | Skills to install, one per line |
| `~/dotfiles/claude/ecc/ecc-agents.txt` | Agents to install, one per line |
| `~/dotfiles/claude/ecc/install-ecc.sh` | Runs ECC's installer for the base (rules, commands, hooks), copies the listed skills and agents, trims rules to your stack |

| Task | How |
| --- | --- |
| Add a skill or agent | Add its name to `ecc-skills.txt` / `ecc-agents.txt` (names = folders in `ECC/skills/`, files in `ECC/agents/`), run `./install-ecc.sh` |
| Turn something off | `"name": "off"` in `skillOverrides` (or `"name-only"` to keep it listed without a description), or delete its folder/file |
| Update ECC | `cd ~/dotfiles/vendor/ECC && git pull && npm install --omit=dev --ignore-scripts && ~/dotfiles/claude/ecc/install-ecc.sh` |
| Preview an update | `./install-ecc.sh --dry-run` |
| See what ECC manages | `cd ~/dotfiles/vendor/ECC && node scripts/ecc.js list-installed` |

Backups from the switch (2026-11-13): `~/.claude/backups/ecc-reinstall-20261113/` (settings and the 21 old skill copies). The earlier plugin folders are in the macOS Trash.

### ECC commands worth knowing

| Command | What it does |
| --- | --- |
| `/ecc-guide` | Map of everything ECC has |
| `/plan` | Restate the task, list risks, write a step-by-step plan, and wait for your OK before coding |
| `/feature-dev` | Guided feature work: explore the code, design, then build |
| `/orch-add-feature`, `/orch-fix-defect`, `/orch-change-feature`, `/orch-refine-code` | End-to-end pipelines: plan, tests first, implement, review, gated commit |
| `/code-review` | Checklist review of local changes or a PR number/URL |
| `/review-pr` | Multi-agent PR review |
| `/orch-review` | Adversarially verified review: blocking vs advisory findings |
| `/build-fix` | Find and fix build or type errors with minimal changes |
| `/python-review`, `/react-review`, `/cpp-review`, ... | Language-specific reviews |
| `/test-coverage` | Find coverage gaps and write the missing tests |
| `/refactor-clean` | Remove dead code safely |
| `/save-session` / `/resume-session` | Save where you are to `~/.claude/session-data/`, pick it up later |
| `/checkpoint` | Create or verify a workflow checkpoint |
| `/cost-report` | Spend summary from ECC's cost log |
| `/prp-commit` | Commit described in plain English ("commit the auth changes") |
| `/pr` | Open a GitHub PR from the current branch |
| `/hookify` | Make a hook rule from a behavior you want to stop. `/hookify-list`, `/hookify-configure` |
| `/aside` | Ask a side question without losing the current task |

### ECC hooks (profile `standard`)

These run automatically. Most only warn; a few block.

| When | Hook | Effect |
| --- | --- | --- |
| Before shell commands | Dev server blocker | Blocks `npm run dev` and similar outside tmux |
| | Git push reminder, tmux reminder | Warnings |
| | Pre-commit check | Lints staged files, checks commit message format, catches `console.log`, `debugger` and secrets. Can block |
| Before edits | GateGuard fact-force | The first edit to a file is blocked until Claude lists what references it, what the change does, and your instruction. Then it retries |
| | Doc file warning | Warns on new `.md`/`.txt` files outside the usual names |
| | Strategic compact | Suggests `/compact` about every 50 tool calls |
| After edits | Quality gate, Prettier, `tsc --noEmit`, `console.log` warning | JS/TS checks |
| Session start | | Loads saved context, detects the package manager |
| Before compaction | | Saves state |
| Stop (each answer) | | Session summary, cost tracker, `console.log` audit, macOS desktop notification |

Turning things down (put these in `settings.json` under `env`, or export them in `.zshrc`):

| Variable | What it does |
| --- | --- |
| `ECC_HOOK_PROFILE` | `minimal`, `standard` (yours) or `strict` |
| `ECC_HOOKS_ENABLED=false` | All ECC hooks off |
| `ECC_DISABLED_HOOKS="id1,id2"` | Turn off specific hooks, e.g. `pre:bash:tmux-reminder,post:edit:typecheck` |
| `ECC_GATEGUARD=off` | GateGuard off entirely |
| `GATEGUARD_EXEMPT_GLOBS` | Skip GateGuard's first-edit check for matching paths (e.g. docs folders) |
| `ECC_SESSION_START_CONTEXT=off` | No extra context at session start |
| `ECC_CONTEXT_MONITOR_COST_WARNINGS=off` | Keep context warnings, drop cost estimates |

Hook docs: `~/dotfiles/vendor/ECC/hooks/README.md`.

### Other plugins

| Plugin | State |
| --- | --- |
| `daloopa`, `data`, `engineering` | Synced from your claude.ai account, switched off in `enabledPlugins` |
| `claude-plugins-official` | Marketplace is registered; nothing installed from it. Browse with `/plugin` |

## Skills

Skills are instructions Claude loads when a task matches, or when you type `/<skill-name>`.

| Where | What | State |
| --- | --- | --- |
| `~/.claude/skills/` | 43 ECC skills (see [ECC](#ecc)) | On. Change via `ecc-skills.txt` + `install-ecc.sh`, or `skillOverrides` |
| `~/.claude/skills/synced/` (claude.ai) | `docx`, `pdf`, `pptx`, `xlsx`, `deep-research`, `docs`, `google-workspace`, `chrome-browser`, `built-in-browser`, `computer-use`, `morning`, `skill-creator`, `import-memory` | On, as `anthropic-skills:*` |
| Built in | `code-review`, `simplify`, `loop`, `schedule`, `update-config`, `keybindings-help`, `claude-api`, `init`, `security-review`, `fewer-permission-prompts`, `run` | On |

To turn a skill or command on or off: edit `skillOverrides` in `settings.json` (`"name": "off"` or `"name-only"`), or use `/skills` (Space cycles states). Note that `skillOverrides` doesn't affect skills that come from plugins. `~/.claude/skills/learned/` (empty) is where `/learn` saves new ones.

## MCP servers and connectors

You have no MCP servers added by hand (`claude mcp list` is empty). Tools come from:

| Source | What | Notes |
| --- | --- | --- |
| claude.ai connectors | Google Drive, Any.do, Claude Docs, Supabase | Connected |
| claude.ai connectors | Gmail, Google Calendar, Mermaid Chart | Need login: run `/mcp` and pick one |
| ECC plugin | chrome-devtools (open pages, click, screenshot, Lighthouse, performance traces) | Starts on demand |

Manage connectors at claude.ai → Settings → Connectors; they follow you into Claude Code.

## Claude Code in Neovim

The LazyVim `ai.claudecode` extra (details in [NEOVIM.md](NEOVIM.md#plugins)):

| Keys | What it does |
| --- | --- |
| `<leader>ac` | Toggle the Claude panel |
| `<leader>af` | Focus it |
| `<leader>ar` / `<leader>aC` | Resume / continue a session |
| `<leader>ab` | Add the current buffer to Claude's context |
| `<leader>as` | Send the selection (or the file under the cursor in neo-tree) |
| `<leader>aa` / `<leader>ad` | Accept / deny the diff Claude proposed |

The other direction: `Ctrl-G` in a Claude prompt opens Neovim to write a long prompt.

## Problems and to-dos

| Item | Fix |
| --- | --- |
| Auto-updates are off | Run `claude update` now and then, or turn auto-updates back on in `/config` |
| GateGuard blocks Claude's first edit to every file, which adds a round-trip | Set `GATEGUARD_EXEMPT_GLOBS` for folders like `~/dotfiles/**`, or add `pre:edit-write:gateguard-fact-force` to `ECC_DISABLED_HOOKS` |
| The dev server blocker wants tmux, which isn't installed | `brew install tmux`, or add the dev-server hook's ID to `ECC_DISABLED_HOOKS` if it gets in the way |
| No global `~/.claude/CLAUDE.md` | Optional: put standing preferences there (e.g. "use uv for Python", "my code is in ~/dev") |

## Change log

- 2026-11-13: Skill list brought under Claude's listing budget (was 36.6k of 30k chars): 25 more commands `off` (epic-*, jira, loop-*, skill tooling, …) and 25 set to `name-only` (ecc-guide, save/resume-session, prp-*, hookify*, …).
- 2026-11-13: Replaced the ECC plugin with a direct install of just what you need: 43 skills, 30 agents, 98 commands (35 off), stack-only rules. Skill listing went from 400+ entries to 123.
- 2026-11-13 (superseded): Switched to a trimmed ECC (`ecc@ecc-local`): 116 skills, 22 agents and 18 commands for unused languages and domains removed; always-on cost ~48.1k → ~31.5k tokens.
- 2026-11-13: First version, written from `settings.json`, `installed_plugins.json`, ECC 2.2.3's hook docs and `claude --help`.
