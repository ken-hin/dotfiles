#!/usr/bin/env bash
# Symlink every config in ~/dotfiles to where its tool expects it.
# Safe to re-run. If a real file is already at a target, it's moved to
# ~/.dotfiles-backup/<timestamp>/ before the link is made.
#   ./link.sh          make or repair all links
#   ./link.sh --check  report status only, change nothing
set -euo pipefail
D="$(cd "$(dirname "$0")" && pwd)"
CHECK=0; [[ "${1:-}" == "--check" ]] && CHECK=1
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# source (relative to ~/dotfiles)            -> target
LINKS=(
  "zsh/zshrc                                  $HOME/.zshrc"
  "zsh/zprofile                               $HOME/.zprofile"
  "zsh/modern-dark-pro-capsule/modern-dark-pro-capsule.zsh-theme  $HOME/.oh-my-zsh/custom/themes/modern-dark-pro-capsule.zsh-theme"
  "nvim                                       $HOME/.config/nvim"
  "ghostty/config                             $HOME/.config/ghostty/config"
  "git/gitconfig                              $HOME/.gitconfig"
  "git/ignore                                 $HOME/.config/git/ignore"
  "claude/settings.json                       $HOME/.claude/settings.json"
)
for f in "$D"/zsh/znt/*.conf; do LINKS+=("zsh/znt/$(basename "$f")  $HOME/.config/znt/$(basename "$f")"); done

ok=0; fixed=0; bad=0
for entry in "${LINKS[@]}"; do
  read -r src dst <<<"$entry"
  src="$D/$src"
  if [[ ! -e "$src" ]]; then echo "MISSING source: $src" >&2; bad=$((bad+1)); continue; fi
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then ok=$((ok+1)); continue; fi
  if (( CHECK )); then echo "needs link: $dst -> $src"; bad=$((bad+1)); continue; fi
  mkdir -p "$(dirname "$dst")"
  if [[ -e "$dst" || -L "$dst" ]]; then
    mkdir -p "$BACKUP"; mv "$dst" "$BACKUP/$(echo "${dst#$HOME/}" | tr / _)"
    echo "backed up old $dst"
  fi
  ln -s "$src" "$dst"; echo "linked $dst"; fixed=$((fixed+1))
done
echo "links ok: $ok, made: $fixed, problems: $bad"
(( bad == 0 ))
