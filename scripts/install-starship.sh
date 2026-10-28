#!/usr/bin/env bash
set -e
if command -v starship >/dev/null 2>&1; then
  echo "starship already installed: $(starship --version | head -1)"
  exit 0
fi

if [[ "$(uname)" == "Darwin" ]] && command -v brew >/dev/null 2>&1; then
  brew install starship
else
  mkdir -p "$HOME/.local/bin"
  curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"
fi
