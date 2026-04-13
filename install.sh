#!/usr/bin/env bash
# =============================================================================
# install.sh — Dotfiles installer (Linux & macOS)
# =============================================================================
set -e

OS="$(uname -s)"
echo ">>> Detected OS: $OS"

# --- Proxy reminder ----------------------------------------------------------
echo ""
echo "============================================================"
echo "  REMINDER: If you're on a corporate/restricted network,"
echo "  set your proxy before continuing, e.g.:"
echo ""
echo "    export http_proxy=http://<proxy-host>:<port>"
echo "    export https_proxy=http://<proxy-host>:<port>"
echo "============================================================"
echo ""

# --- Menu --------------------------------------------------------------------
echo "What would you like to install?"
echo "  1) Install starship and update .zshrc"
echo "  2) Install and configure neovim"
echo "  3) Both"
echo ""
read -rp "Enter choice [1/2/3]: " CHOICE

case "$CHOICE" in
  1) DO_STARSHIP=true;  DO_NEOVIM=false ;;
  2) DO_STARSHIP=false; DO_NEOVIM=true  ;;
  3) DO_STARSHIP=true;  DO_NEOVIM=true  ;;
  *) echo "Invalid choice. Exiting."; exit 1 ;;
esac

# --- Install dependencies ----------------------------------------------------
if [[ "$OS" == "Darwin" ]]; then
  if ! command -v brew &>/dev/null; then
    echo ">>> Installing Homebrew..."
    /bin/bash -c "$(curl --proto '=https' --tlsv1.2 -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  if [[ "$DO_STARSHIP" == true ]]; then
    echo ">>> Installing starship via Homebrew..."
    brew install starship
    echo ">>> Installing zoxide via Homebrew..."
    brew install zoxide
  fi
  if [[ "$DO_NEOVIM" == true ]]; then
    echo ">>> Installing neovim via Homebrew..."
    brew install neovim

    echo ">>> Installing neovim CLI dependencies (ripgrep, fd, bat, fzf)..."
    brew install ripgrep fd bat fzf
  fi

elif [[ "$OS" == "Linux" ]]; then
  if [[ "$DO_STARSHIP" == true ]]; then
    if ! command -v starship &>/dev/null; then
      echo ">>> Installing starship..."
      curl --proto '=https' --tlsv1.2 -sS https://starship.rs/install.sh | sh -s -- --yes
    else
      echo ">>> starship already installed, skipping."
    fi
    if ! command -v zoxide &>/dev/null; then
      echo ">>> Installing zoxide..."
      curl --proto '=https' --tlsv1.2 -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    else
      echo ">>> zoxide already installed, skipping."
    fi
  fi
  if [[ "$DO_NEOVIM" == true ]]; then
    if ! command -v nvim &>/dev/null; then
      echo ">>> nvim not found — install it manually (apt/snap/etc.) then re-run"
      exit 1
    fi

    echo ">>> Installing neovim CLI dependencies (ripgrep, fd, bat, fzf)..."
    if command -v apt-get &>/dev/null; then
      sudo apt-get update -qq
      # Note: fd is packaged as 'fd-find' on Debian/Ubuntu; 'fdfind' becomes the binary.
      # We create a symlink so 'fd' works as expected.
      sudo apt-get install -y ripgrep fd-find bat fzf
      if ! command -v fd &>/dev/null; then
        mkdir -p "$HOME/.local/bin"
        ln -sf "$(which fdfind)" "$HOME/.local/bin/fd"
        echo ">>> Symlinked fdfind -> ~/.local/bin/fd (ensure ~/.local/bin is in your PATH)"
      fi
      # On some Debian/Ubuntu versions bat is packaged as 'batcat'
      if ! command -v bat &>/dev/null && command -v batcat &>/dev/null; then
        mkdir -p "$HOME/.local/bin"
        ln -sf "$(which batcat)" "$HOME/.local/bin/bat"
        echo ">>> Symlinked batcat -> ~/.local/bin/bat (ensure ~/.local/bin is in your PATH)"
      fi
    elif command -v dnf &>/dev/null; then
      sudo dnf install -y ripgrep fd-find bat fzf
    elif command -v yum &>/dev/null; then
      sudo yum install -y ripgrep fd-find bat fzf
    elif command -v pacman &>/dev/null; then
      sudo pacman -S --noconfirm ripgrep fd bat fzf
    else
      echo ">>> WARNING: Could not detect package manager."
      echo "    Please install ripgrep, fd, bat, and fzf manually."
    fi
  fi
fi

# --- Link config files -------------------------------------------------------
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$DO_STARSHIP" == true ]]; then
  if [[ -f "$HOME/.zshrc" ]]; then
    echo ">>> Backing up ~/.zshrc to ~/.zshrc.bak-pre-dotfiles..."
    cp "$HOME/.zshrc" "$HOME/.zshrc.bak-pre-dotfiles"
  fi

  echo ">>> Linking .zshrc..."
  ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

  echo ">>> Linking starship.toml..."
  mkdir -p "$HOME/.config"
  ln -sf "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"
fi

if [[ "$DO_NEOVIM" == true ]]; then
  echo ">>> Linking nvim config..."
  mkdir -p "$HOME/.config/nvim"
  ln -sf "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"

  echo ">>> Linking bat config..."
  mkdir -p "$HOME/.config/bat"
  ln -sf "$DOTFILES_DIR/bat/config" "$HOME/.config/bat/config"
fi

echo ""
echo ">>> Done!"
if [[ "$DO_STARSHIP" == true ]]; then
  echo ">>> Open a new terminal or run: source ~/.zshrc"
  echo ">>> zoxide powers smart directory jumping (zi, Ctrl+F) — installed ✅"
fi
if [[ "$DO_NEOVIM" == true ]]; then
  echo ">>> Open nvim — plugins will install automatically on first launch."
  echo ">>> Telescope live_grep requires ripgrep — installed ✅"
  echo ">>> Telescope find_files works better with fd — installed ✅"
  echo ">>> bat provides syntax-highlighted previews — installed ✅"
  echo ">>> bat config linked (~/.config/bat/config) — gruvbox-dark theme ✅"
  echo ">>> fzf powers fuzzy file/directory pickers (vf, zi) — installed ✅"
fi

