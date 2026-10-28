#!/usr/bin/env bash
# Sets up skillshare on a new machine, or pulls the latest skills on an existing one.
# The skills repo is private, so gh must be logged in first (gh auth login).
set -euo pipefail

REMOTE="https://github.com/tel3342311/skillshare-config.git"

# A fresh shell may not have these on PATH yet.
export PATH="/opt/homebrew/bin:/etc/profiles/per-user/$(id -un)/bin:/run/current-system/sw/bin:$PATH"

if ! command -v skillshare >/dev/null 2>&1; then
  echo "skillshare is not installed yet. Run ./rebuild.sh first."
  exit 1
fi

if ! command -v gh >/dev/null 2>&1 || ! gh auth status >/dev/null 2>&1; then
  echo "gh is not logged in, and the skills repo is private."
  echo "Run: gh auth login"
  echo "Then re-run: ./sync-skills.sh"
  exit 1
fi

if [ -f "$HOME/.config/skillshare/config.yaml" ]; then
  skillshare pull
else
  # init with --remote also pulls the skills and links them into every detected tool.
  skillshare init --remote "$REMOTE" --all-targets --no-copy --no-skill
fi
