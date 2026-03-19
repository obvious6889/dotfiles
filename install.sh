#!/usr/bin/env bash
# =============================================================================
# install.sh — Dotfiles installer (Linux & macOS)
# =============================================================================
set -e

OS="$(uname -s)"
echo ">>> Detected OS: $OS"

# --- Install dependencies ----------------------------------------------------
if [[ "$OS" == "Darwin" ]]; then
  if ! command -v brew &>/dev/null; then
    echo ">>> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  echo ">>> Installing neovim and starship via Homebrew..."
  brew install neovim starship
elif [[ "$OS" == "Linux" ]]; then
  if ! command -v starship &>/dev/null; then
    echo ">>> Installing starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
  else
    echo ">>> starship already installed, skipping."
  fi
  if ! command -v nvim &>/dev/null; then
    echo ">>> nvim not found — install it manually (apt/snap/etc.) then re-run"
    exit 1
  fi
fi

# --- Link config files -------------------------------------------------------
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ">>> Linking .zshrc..."
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

echo ">>> Linking starship.toml..."
mkdir -p "$HOME/.config"
ln -sf "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"

echo ">>> Linking nvim config..."
mkdir -p "$HOME/.config/nvim"
ln -sf "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"

echo ""
echo ">>> Done! Open a new terminal or run: source ~/.zshrc"
echo ">>> Then open nvim — plugins will install automatically on first launch."
