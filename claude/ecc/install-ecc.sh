#!/usr/bin/env bash
# Install or update Kenneth's slim ECC setup into ~/.claude.
#   Base (ECC installer): rules, slash commands, hooks, platform config.
#   Picked by hand: skills in ecc-skills.txt, agents in ecc-agents.txt (copied as plain files).
# Update: (cd ~/dotfiles/vendor/ECC && git pull && npm install --omit=dev --ignore-scripts) && ~/dotfiles/claude/ecc/install-ecc.sh
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
ECC="$(cd "$HERE/../../vendor/ECC" && pwd)"
CLAUDE="$HOME/.claude"

# ECC's installer refuses to write to ~/.claude/settings.json when it's a symlink
# into ~/dotfiles. Swap in a real copy for the run, then put the result back.
SETTINGS="$CLAUDE/settings.json"
if [[ -L "$SETTINGS" ]]; then
  SETTINGS_SRC="$(readlink "$SETTINGS")"
  rm "$SETTINGS"; cp "$SETTINGS_SRC" "$SETTINGS"
  restore_settings() { cp "$SETTINGS" "$SETTINGS_SRC" && rm "$SETTINGS" && ln -s "$SETTINGS_SRC" "$SETTINGS"; }
  trap restore_settings EXIT
fi

(cd "$ECC" && node scripts/install-apply.js --target claude \
  --modules rules-core,commands-core,hooks-runtime,platform-configs --enable-hooks "$@")
[[ " $* " == *" --dry-run "* ]] && exit 0

mkdir -p "$CLAUDE/skills" "$CLAUDE/agents"
n=0; while read -r s; do [[ -z "$s" || "$s" == \#* ]] && continue
  [ -d "$ECC/skills/$s" ] || { echo "skip: no skill '$s' in ECC" >&2; continue; }
  rsync -a --delete "$ECC/skills/$s/" "$CLAUDE/skills/$s/"; n=$((n+1))
done < "$HERE/ecc-skills.txt"
m=0; while read -r a; do [[ -z "$a" || "$a" == \#* ]] && continue
  [ -f "$ECC/agents/$a.md" ] || { echo "skip: no agent '$a' in ECC" >&2; continue; }
  cp "$ECC/agents/$a.md" "$CLAUDE/agents/$a.md"; m=$((m+1))
done < "$HERE/ecc-agents.txt"
# Keep only rule packs for your stack. Language packs load only for matching files;
# common/ loads every session. README.md is just an index. Extras go to the macOS Trash.
RULES="$CLAUDE/rules/ecc"; KEEP_RULES="common python typescript java react web"
for d in "$RULES"/*/; do b="$(basename "$d")"; [[ " $KEEP_RULES " == *" $b "* ]] || trash "$d"; done
[ -f "$RULES/README.md" ] && trash "$RULES/README.md"

echo "ECC base installed; $n skills and $m agents copied. Restart Claude Code to load them."
