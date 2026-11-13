#!/usr/bin/env bash
# Set up a Mac from this repo. Safe to re-run: every step skips work already done.
#   git clone https://github.com/ken-hin/dotfiles.git ~/dotfiles && ~/dotfiles/bootstrap.sh
set -euo pipefail
D="$(cd "$(dirname "$0")" && pwd)"
step() { printf '\n==> %s\n' "$*"; }
warn() { printf '  ! %s\n' "$*"; }

step "Xcode command line tools"
xcode-select -p >/dev/null 2>&1 || { xcode-select --install; echo "Finish the Xcode tools install, then re-run this script."; exit 1; }

step "Homebrew"
if ! command -v brew >/dev/null 2>&1 && [[ ! -x /opt/homebrew/bin/brew ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

step "Packages from Brewfile"
brew bundle --no-upgrade --file="$D/Brewfile"

step "Oh My Zsh"
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
for repo in zsh-users/zsh-autosuggestions zsh-users/zsh-syntax-highlighting; do
  name="${repo#*/}"
  if [[ ! -d "$ZSH_CUSTOM/plugins/$name" && ! -d "$HOME/.oh-my-zsh/plugins/$name" ]]; then
    git clone --depth 1 "https://github.com/$repo.git" "$ZSH_CUSTOM/plugins/$name"
  fi
done

step "Linking configs"
"$D/link.sh"

step "Neovim plugins (from lazy-lock.json)"
nvim --headless "+Lazy! restore" +qa || warn "Neovim plugin restore had errors; open nvim and run :Lazy"

step "ECC for Claude Code"
if [[ ! -d "$D/vendor/ECC" ]]; then
  git clone https://github.com/affaan-m/ECC.git "$D/vendor/ECC"
  git -C "$D/vendor/ECC" checkout -q "$(cat "$D/claude/ecc/ECC_COMMIT")"
fi
(cd "$D/vendor/ECC" && npm install --omit=dev --ignore-scripts --no-audit --no-fund)
"$D/claude/ecc/install-ecc.sh"

step "Things this script doesn't install"
command -v claude >/dev/null 2>&1 || warn "Claude Code: curl -fsSL https://claude.ai/install.sh | bash"
[[ -d /Library/Frameworks/Python.framework/Versions/3.13 ]] || warn "Python 3.13 from python.org (zprofile puts it ahead of Homebrew's)"
command -v uv  >/dev/null 2>&1 || warn "uv: curl -LsSf https://astral.sh/uv/install.sh | sh"
command -v bun >/dev/null 2>&1 || warn "bun: curl -fsSL https://bun.sh/install | bash"
[[ -d /Applications/Docker.app ]] || warn "Docker Desktop (docker, docker-compose, Docker completions)"
[[ -d "$HOME/Library/Application Support/JetBrains/Toolbox" ]] || warn "JetBrains Toolbox (optional)"

step "Log in by hand"
echo "  gh auth login        # GitHub CLI"
echo "  claude               # Claude Code, then /login"
echo "  Open a new Ghostty tab to load the shell config."
