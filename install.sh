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
echo "  1) Starship + .zshrc"
echo "  2) Neovim"
echo "  3) tmux"
echo "  4) Ghostty"
echo "  5) All"
echo ""
read -rp "Enter choice [1/2/3/4/5]: " CHOICE

case "$CHOICE" in
  1) DO_STARSHIP=true;  DO_NEOVIM=false; DO_TMUX=false; DO_GHOSTTY=false ;;
  2) DO_STARSHIP=false; DO_NEOVIM=true;  DO_TMUX=false; DO_GHOSTTY=false ;;
  3) DO_STARSHIP=false; DO_NEOVIM=false; DO_TMUX=true;  DO_GHOSTTY=false ;;
  4) DO_STARSHIP=false; DO_NEOVIM=false; DO_TMUX=false; DO_GHOSTTY=true  ;;
  5) DO_STARSHIP=true;  DO_NEOVIM=true;  DO_TMUX=true;  DO_GHOSTTY=true  ;;
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
  if [[ "$DO_TMUX" == true ]]; then
    echo ">>> Installing tmux via Homebrew..."
    brew install tmux xclip 2>/dev/null || brew install tmux
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
  if [[ "$DO_TMUX" == true ]]; then
    if ! command -v tmux &>/dev/null; then
      echo ">>> Installing tmux..."
      if command -v apt-get &>/dev/null; then
        sudo apt-get update -qq && sudo apt-get install -y tmux xclip
      elif command -v dnf &>/dev/null; then
        sudo dnf install -y tmux xclip
      elif command -v yum &>/dev/null; then
        sudo yum install -y tmux xclip
      elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm tmux xclip
      else
        echo ">>> WARNING: Could not detect package manager. Install tmux + xclip manually."
      fi
    else
      echo ">>> tmux already installed, skipping."
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

if [[ "$DO_TMUX" == true ]]; then
  if [[ -f "$HOME/.tmux.conf" && ! -L "$HOME/.tmux.conf" ]]; then
    echo ">>> Backing up ~/.tmux.conf to ~/.tmux.conf.bak-pre-dotfiles..."
    cp "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak-pre-dotfiles"
  fi

  echo ">>> Linking .tmux.conf..."
  ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"

  echo ">>> Creating ~/tmux-logs/ for per-window logs..."
  mkdir -p "$HOME/tmux-logs"

  if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    echo ">>> Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  else
    echo ">>> TPM already installed, skipping."
  fi
fi

if [[ "$DO_GHOSTTY" == true ]]; then
  if [[ "$OS" == "Darwin" ]]; then
    GHOSTTY_CONFIG_DIR="$HOME/Library/Application Support/com.mitchellh.ghostty"
  else
    GHOSTTY_CONFIG_DIR="$HOME/.config/ghostty"
  fi

  if [[ -f "$GHOSTTY_CONFIG_DIR/config" && ! -L "$GHOSTTY_CONFIG_DIR/config" ]]; then
    echo ">>> Backing up Ghostty config to ${GHOSTTY_CONFIG_DIR}/config.bak-pre-dotfiles..."
    cp "$GHOSTTY_CONFIG_DIR/config" "$GHOSTTY_CONFIG_DIR/config.bak-pre-dotfiles"
  fi

  echo ">>> Linking Ghostty config..."
  mkdir -p "$GHOSTTY_CONFIG_DIR"
  ln -sf "$DOTFILES_DIR/ghostty/config" "$GHOSTTY_CONFIG_DIR/config"
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
if [[ "$DO_TMUX" == true ]]; then
  echo ">>> .tmux.conf linked (~/.tmux.conf) ✅"
  echo ">>> Per-window logs go to ~/tmux-logs/ ✅"
  echo ">>> Prefix is C-a. Reload config: C-a r"
  echo ">>> TPM installed — press C-a I inside tmux to install plugins."
fi
if [[ "$DO_GHOSTTY" == true ]]; then
  echo ">>> Ghostty config linked ✅"
  echo ">>> Reload in Ghostty: Cmd+Shift+, (macOS) or Ctrl+Shift+, (Linux)"
fi

