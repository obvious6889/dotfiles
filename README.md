# shell-setup

Personal shell and editor configuration for zsh, Starship, Neovim, tmux, and Ghostty.

## What's included

- `.zshrc`: Zsh configuration (history, aliases, keybindings, functions)
- `starship.toml`: Starship prompt configuration using a gruvbox-dark palette
- `nvim/init.lua`: Neovim configuration (lazy.nvim, neo-tree, Telescope, Treesitter, lualine, gruvbox)
- `.tmux.conf`: tmux configuration (prefix `C-a`, mouse, vi copy mode, per-window logging, plugins)
- `ghostty/config`: Ghostty terminal configuration (theme, font, opacity, keybinds)
- `KEYBINDINGS.md`: Quick reference for Neovim, zsh, and tmux keys/commands

The prompt and editor both use a gruvbox-aligned look for visual consistency.

## Dependencies

### Installed by `install.sh` when Starship is selected

| Tool | Why it is needed |
| ---- | ---------------- |
| `zoxide` | Smart directory jumping (`zi`, also mapped to `Ctrl+F`) |

### Ghostty config (no dependencies)

Ghostty must already be installed. The installer only links the config file.

> **Font:** `MesloLGS Nerd Font Mono` must be installed on the machine. Download from [nerdfonts.com](https://www.nerdfonts.com/).
> **Blur:** `background-blur-radius` works on macOS and Linux compositors that support blur (GNOME with blur plugin, KWin). Silently ignored otherwise.

### Installed by `install.sh` when tmux is selected

| Tool | Why it is needed |
| ---- | ---------------- |
| `tmux` | Terminal multiplexer |
| `xclip` | Clipboard integration in copy mode (Linux only) |
| `tpm` | Plugin manager — cloned to `~/.tmux/plugins/tpm` |

Plugins installed via TPM:

| Plugin | Purpose |
| ------ | ------- |
| `tmux-sensible` | Sane defaults |
| `tmux-resurrect` | Save/restore sessions across reboots (`C-a C-s` / `C-a C-r`) |
| `tmux-continuum` | Auto-save sessions every 15 min |

> **Airgapped machines:** pack plugins with `tar czf tmux-plugins.tar.gz -C ~ .tmux/plugins` and `scp` to the remote. No internet needed after that.

### Installed by `install.sh` when Neovim is selected

| Tool | Why it is needed |
| ---- | ---------------- |
| `ripgrep` | Telescope `live_grep` searching |
| `fd` (`fd-find` on Debian/Ubuntu) | Faster Telescope file discovery |
| `bat` (`batcat` on Debian/Ubuntu) | Syntax-highlighted previews in `vf` |
| `fzf` | Fuzzy picker for `vf` and `zi` workflows |

## Setting up on a new machine

```zsh
git clone https://github.com/obvious6889/dotfiles.git
cd dotfiles
bash install.sh
```

If you are on a restricted network, set proxy variables before running:

```zsh
export http_proxy=http://<proxy-host>:<port>
export https_proxy=http://<proxy-host>:<port>
```

The installer will:

1. Ask what to install:
   - Option 1: Starship and `.zshrc`
   - Option 2: Neovim config and dependencies
   - Option 3: tmux config and plugins
   - Option 4: Ghostty config
   - Option 5: All
2. Install Homebrew on macOS if needed
3. Install selected packages
4. Back up existing `~/.zshrc` to `~/.zshrc.bak-pre-dotfiles` (if present)
5. Create/update symlinks to your home config locations

Then open a new terminal. If Neovim was installed, run `nvim` once so plugins can install on first launch.

## Platform-specific behavior

- macOS:
  - Homebrew is auto-installed if missing.
  - Selecting Starship installs `zoxide` via Homebrew.
  - Selecting Neovim installs `neovim`, `ripgrep`, `fd`, `bat`, and `fzf` via Homebrew.
- Linux:
  - `nvim` must already exist; otherwise installer exits and asks you to install it first.
  - Selecting Starship installs `zoxide` via the official install script (`raw.githubusercontent.com/ajeetdsouza/zoxide`). Binary lands in `~/.local/bin`.
  - Installer attempts dependency install via `apt-get`, `dnf`, `yum`, or `pacman`.
  - On Debian/Ubuntu, installer creates compatibility links when needed:
    - `fdfind` -> `~/.local/bin/fd`
    - `batcat` -> `~/.local/bin/bat`
  - tmux option installs `tmux` + `xclip` via the detected package manager.

## Font requirement

A Nerd Font is required for prompt/icons to render correctly.
Download from [nerdfonts.com](https://www.nerdfonts.com/) and configure it in your terminal.
Recommended examples: JetBrainsMono Nerd Font, FiraCode Nerd Font.

## Making changes

Configs in this folder are symlinked into your home config paths, so editing either side updates the same effective config.

After changes:

```zsh
cd ~/dotfiles
git add .
git commit -m "describe your change"
git push
```

## Pulling updates on other machines

```zsh
cd ~/dotfiles
git pull
```

No extra copy step is needed because symlinks keep config live.

## Quick reference

| Source file in repo | Symlink target |
| ------------------- | -------------- |
| `.zshrc` | `~/.zshrc` |
| `starship.toml` | `~/.config/starship.toml` |
| `nvim/init.lua` | `~/.config/nvim/init.lua` |
| `bat/config` | `~/.config/bat/config` |
| `.tmux.conf` | `~/.tmux.conf` |
| `ghostty/config` | `~/Library/Application Support/com.mitchellh.ghostty/config` (macOS) |
| `ghostty/config` | `~/.config/ghostty/config` (Linux) |
