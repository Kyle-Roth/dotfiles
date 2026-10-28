#!/usr/bin/env bash
set -e

# Packages to install on each OS
DEBIAN_PKGS=(zsh vim git curl vivid)
BREW_PKGS=(vim vivid)

case "$(uname)" in
  Linux)
    if command -v apt-get >/dev/null 2>&1; then
      missing=()
      for p in "${DEBIAN_PKGS[@]}"; do
        dpkg -s "$p" >/dev/null 2>&1 || missing+=("$p")
      done
      if ((${#missing[@]})); then
        echo "Installing: ${missing[*]}"
        sudo apt-get update
        sudo apt-get install -y "${missing[@]}"
      else
        echo "All apt packages already installed"
      fi
    fi
    ;;
  Darwin)
    if command -v brew >/dev/null 2>&1; then
      for p in "${BREW_PKGS[@]}"; do
        brew list --formula "$p" >/dev/null 2>&1 || brew install "$p"
      done
    else
      echo "Homebrew not found, skipping brew packages"
    fi
    ;;
esac

# Make zsh the default login shell
ZSH_PATH="$(command -v zsh)"
if [ "$(basename "${SHELL:-}")" != "zsh" ]; then
  grep -qx "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
  echo "Changing default shell to $ZSH_PATH"
  chsh -s "$ZSH_PATH"
else
  echo "zsh is already the default shell"
fi
