# Running AI Locally on Your Mac Mini (M2 Pro, 16GB)

A practical guide to setting up a local model for everyday tasks — and giving it
Claude-like powers: file access, code editing, and MCP servers. Keep this handy
as a reference.

---

## Part 1 — The Basics: Get a Model Running

### Why your machine is well suited for this
Apple Silicon uses *unified memory*, so the GPU has fast access to your 16GB.
With Metal/MLX acceleration, a Mac Mini M2 Pro comfortably runs small-to-mid
models. Plan on roughly **10–11GB usable** for a model after macOS takes its share.

### Model size guide for your 16GB
| Model size (4-bit) | Fits? | Notes |
|---|---|---|
| 3B–8B | Yes, easily | Fast. Your everyday sweet spot. |
| 14B | Yes | Smarter, slower, less headroom for long chats. |
| 32B+ | No | Needs ~18–20GB. Skip it. |

### Install Ollama (simplest path, ~10 min)
1. Download the Mac app from **ollama.com** and install it.
2. Open Terminal and pull a model:
   ```
   ollama run qwen2.5:7b        # excellent all-rounder — start here
   ollama run llama3.1:8b       # strong alternative, great tool support
   ollama run qwen2.5:14b       # more capable; try after 7B feels good
   ```
3. The first run downloads the model (a few GB) and drops you into a chat.

Useful commands:
```
ollama list                 # see installed models
ollama ps                   # see what's loaded in memory
ollama rm <model>           # delete a model to free disk space
/bye                        # exit a chat session
```

### Prefer a chat window? Use LM Studio
Install from **lmstudio.ai**. Same models, a polished GUI, and it can use
Apple's **MLX** runtime, which is slightly faster on your chip. Many people run
both: LM Studio to browse/experiment, Ollama to serve models to other apps.

---

## Part 2 — Making It More Like Claude

Out of the box a local model is just a chat box. The magic of Claude is that it
can *act* — read and write your files, run code, and use tools. You can add each
of those layers locally. Pick the pieces you want.

> **One key concept:** these agentic features rely on *tool calling* (a.k.a.
> function calling). Choose a model that supports it. **Qwen2.5** and
> **Llama 3.1** both do — which is why they're the recommended picks above.

### A. A better chat interface with tools — Open WebUI
A self-hosted, ChatGPT-like web interface for your Ollama models. Adds chat
history, document upload (RAG), web search, and a plugin/tool system.

Easiest install (needs Docker Desktop for Mac):
```
docker run -d -p 3000:8080 \
  --add-host=host.docker.internal:host-gateway \
  -v open-webui:/app/backend/data \
  --name open-webui --restart always \
  ghcr.io/open-webui/open-webui:main
```
Then open **http://localhost:3000** in your browser. It auto-detects Ollama.

### B. Give it your codebase — AI coding assistants

**Continue** (VS Code / JetBrains extension) — free, points at your local
Ollama model. Chat about code, autocomplete, edit-in-place. Good, low-risk
starting point.
- Install the "Continue" extension, open its config, and set the provider to
  Ollama with your model name (e.g. `qwen2.5:7b`).

**Cline** or **Roo Code** (VS Code extensions) — fully *agentic*: they read
files, write edits, and run terminal commands, asking your approval at each
step. This is the closest local experience to Claude editing your project.
Both connect to Ollama and both support **MCP servers** (see below).
- For real agentic coding, use a 14B model if it fits — bigger models follow
  multi-step tool instructions far more reliably.

**Aider** (terminal tool) — AI pair programmer that edits files directly and
makes git commits for each change, so everything is reversible.
```
pip install aider-install && aider-install
aider --model ollama/qwen2.5:14b
```
Run it inside a git repo; it edits real files and commits as it goes.

> **Safety tip:** agentic tools can modify and delete files and run commands.
> Always work inside a **git repository** so every change is tracked and
> revertible, and start with the "ask approval" mode before trusting auto-run.

### C. Connect it to MCP servers (the big one)

**MCP (Model Context Protocol)** is the same open standard Claude uses to
connect to external tools — filesystem access, web search, GitHub, databases,
Slack, and hundreds more. Local models can use MCP too, via a client that
supports it.

Clients that speak both Ollama/local models **and** MCP:
- **LM Studio** — has built-in MCP support. Edit its `mcp.json` to add servers;
  they then appear as tools your local model can call in chat.
- **Cline / Roo Code** — MCP marketplace built in; add servers with a few clicks.
- **Open WebUI** — supports external tools/MCP via its tool system.
- **mcphost** — a lightweight CLI that bridges Ollama models to MCP servers if
  you want a terminal-only setup.

Example: adding the official **filesystem** MCP server (gives the model
controlled read/write access to a folder you choose). In an `mcp.json`:
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/Users/kenneth/Projects"]
    }
  }
}
```
Other popular servers: web fetch/search, GitHub, SQLite/Postgres, memory, and
time. You scope exactly what each server can touch, so you stay in control.

---

## Part 3 — A Sensible Rollout Plan

1. **Week 1:** Install Ollama, run `qwen2.5:7b`, use it daily for drafting,
   summarizing, and quick questions. Get a feel for where local is "good enough."
2. **Week 2:** Add a GUI — LM Studio or Open WebUI — for a nicer experience and
   document uploads.
3. **Week 3:** Add coding powers — Continue for low-risk help, then Cline/Aider
   inside a git repo when you want it to actually edit code.
4. **Week 4:** Wire up one or two MCP servers (filesystem + web) to a client and
   see how far the agentic experience goes.

### Setting expectations
A local 7B–14B model is great for drafting, summarizing, brainstorming, quick
Q&A, and modest coding help. It will be weaker than Claude on long-context
reasoning, complex multi-step tasks, and reliability — exactly the work you'll
still want to hand to Opus 4.8 or Fable 5. The local/cloud split you're planning
is the right instinct.

### The "no token limits" win
Ollama exposes a local API at **http://localhost:11434** in the OpenAI format.
Any app or script that expects an OpenAI-style endpoint can point there and use
your local model for free — no token caps, no per-use cost. With your Gigabit
Ethernet, other devices on your home network can reach it too.
