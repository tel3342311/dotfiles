#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ln -sfn "$DIR" ~/.dotfiles
# The flake has one output per username; resolve it before sudo changes $USER.
HOST="$(id -un)"
exec sudo -H darwin-rebuild switch --flake ~/.dotfiles#"$HOST"
