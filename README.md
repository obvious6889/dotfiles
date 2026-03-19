# dotfiles

Personal configuration files for zsh, starship, and neovim.

## What's included

- `.zshrc` — Zsh configuration (history, aliases, keybindings, etc.)
- `starship.toml` — Starship prompt (gruvbox-rainbow theme)
- `nvim/init.lua` — Neovim configuration (neo-tree, telescope, treesitter, lualine, gruvbox)

---

## Setting up on a new machine

```zsh
git clone https://github.com/obvious6889/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
```

The install script will:
- Install Homebrew (macOS only, if not present)
- Install neovim and starship
- Symlink all config files to the correct locations

Then open a new terminal and run `nvim` — plugins will install automatically on first launch.

> **Note:** A Nerd Font is required for icons and the starship prompt to render correctly.
> Download one from [nerdfonts.com](https://www.nerdfonts.com/) and set it in your terminal's font settings.
> Recommended: **JetBrainsMono Nerd Font** or **FiraCode Nerd Font**.

---

## Making changes

Since all configs are symlinked to `~/dotfiles/`, you can edit either the original path or the dotfiles path — they point to the same file.

After making changes, commit and push from `~/dotfiles/`:

```zsh
cd ~/dotfiles
git add .
git commit -m "describe your change"
git push
```

---

## Pulling changes on other machines

```zsh
cd ~/dotfiles
git pull
```

No further steps needed — symlinks mean the updated files are live immediately.

---

## Quick reference

| File | Symlinked to |
|------|-------------|
| `dotfiles/.zshrc` | `~/.zshrc` |
| `dotfiles/starship.toml` | `~/.config/starship.toml` |
| `dotfiles/nvim/init.lua` | `~/.config/nvim/init.lua` |
