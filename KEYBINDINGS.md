# Keybindings Reference

## Neovim

### General

| Key | Action |
| --- | ------ |
| `Space+e` | Toggle neo-tree |
| `Space+o` | Focus neo-tree |
| `Space+ff` | Find files (Telescope) |
| `Space+fg` | Live grep |
| `Space+fb` | Buffers |
| `Space+fh` | Help tags |
| `Space+gb` | Git branches (Telescope) |
| `Space+gs` | Git status (Telescope) |
| `Space+gc` | Git commits (Telescope) |
| `Space+q` | Quit without saving |
| `Space+p` | Paste without overwriting clipboard |
| `Shift+H` | Previous buffer |
| `Shift+L` | Next buffer |
| `Ctrl+H` | Move to left window |
| `Ctrl+J` | Move to lower window |
| `Ctrl+K` | Move to upper window |
| `Ctrl+L` | Move to right window |
| `Ctrl+D` | Scroll down (centered) |
| `Ctrl+U` | Scroll up (centered) |
| `n` | Next search result (centered) |
| `N` | Previous search result (centered) |
| `J` (visual) | Move selected line(s) down |
| `K` (visual) | Move selected line(s) up |
| `gcc` | Toggle comment |
| `Esc` | Clear search highlight |

### Neo-tree (inside the tree window)

| Key | Action |
| --- | ------ |
| `Enter` | Open file / expand folder |
| `l` | Open file / expand folder (custom) |
| `h` | Collapse folder (custom) |
| `a` | Add file |
| `A` | Add directory |
| `d` | Delete |
| `r` | Rename |
| `y` | Copy filename |
| `Y` | Copy relative path |
| `x` | Cut |
| `p` | Paste |
| `c` | Copy |
| `m` | Move |
| `q` | Close neo-tree |
| `R` | Refresh |
| `?` | Show help |
| `<` | Previous source |
| `>` | Next source |

## Zsh

| Key | Action |
| --- | ------ |
| `Ctrl+A` | Beginning of line |
| `Ctrl+E` | End of line |
| `Ctrl+R` | Search history |
| `Ctrl+F` | zoxide interactive directory picker (`zi`) |
| `Up arrow` | Search history backward |
| `Down arrow` | Search history forward |
| `Home` | Beginning of line |
| `End` | End of line |
| `Delete` | Delete character under cursor |
| `Ctrl+Right` | Forward word |
| `Ctrl+Left` | Backward word |

### Shell Commands and Functions

| Command | Action |
| ------- | ------ |
| `mkcd [dir]` | Create a directory and immediately `cd` into it |
| `extract [archive]` | Extract common archive formats |
| `f [pattern]` | Find files by name recursively using `fd` (respects `.gitignore`, supports flags e.g. `-e py`, `-t d`) |
| `vf [query]` | Open file in nvim via fzf (tab for multi-select, optional pre-filter) |
| `zi [query]` | Interactive zoxide directory picker (also bound to `Ctrl+F`) |
| `hsi [pattern]` | Search shell history case-insensitively |
| `cat [file]` | Alias to `bat` — syntax-highlighted output with line numbers and git changes |

## tmux

Prefix key: `C-a` (hold Ctrl, tap a)

### Sessions & Server

| Key | Action |
| --- | ------ |
| `tmux new -s <name>` | New named session |
| `tmux ls` | List sessions |
| `tmux attach -t <name>` | Attach to session |
| `C-a S` | Interactive session switcher |
| `C-a R` | Rename current session |
| `C-a d` | Detach (session stays alive) |
| `C-a $` | Rename session (built-in) |

### Windows

| Key | Action |
| --- | ------ |
| `C-a c` | New window (inherits CWD) |
| `C-a ,` | Rename current window |
| `C-a w` | Interactive window list |
| `C-a &` | Kill current window |
| `M-1` … `M-9` | Jump to window 1–9 (no prefix) |
| `M-h` | Previous window (no prefix) |
| `M-l` | Next window (no prefix) |
| `M-H` | Move window left (no prefix) |
| `M-L` | Move window right (no prefix) |

### Panes

| Key | Action |
| --- | ------ |
| `C-a \|` | Split vertically (right) |
| `C-a -` | Split horizontally (below) |
| `C-h/j/k/l` | Navigate panes (vim-aware, no prefix) |
| `C-a z` | Zoom/unzoom pane (fullscreen toggle) |
| `C-a x` | Kill pane |
| `C-a q` | Show pane numbers |
| `C-a {` | Swap pane left |
| `C-a }` | Swap pane right |
| `C-a H/J/K/L` | Resize pane (repeatable, with prefix) |

### Copy Mode (vi)

| Key | Action |
| --- | ------ |
| `C-a [` | Enter copy/scroll mode |
| `v` | Begin selection |
| `V` | Select whole line |
| `C-v` | Rectangle selection |
| `y` | Copy selection → clipboard, exit mode |
| `q` | Exit copy mode |
| `Page Up / Down` | Scroll by page |
| `/` | Search forward |
| `?` | Search backward |
| `n / N` | Next / previous match |

### Logging

| Key | Action |
| --- | ------ |
| `C-a P` | Toggle per-window log (`~/tmux-logs/`) |
| Auto | Every new window logs automatically |

### Utility

| Key | Action |
| --- | ------ |
| `C-a r` | Reload `~/.tmux.conf` |
| `C-a ?` | Show all keybindings |
| `M-s` | SSH to hostname in clipboard (no prefix) |
| `C-a t` | Show clock |

### Zsh (macOS only)

| Command | Action |
| ------- | ------ |
| `ofd` | Open current directory in Finder |
| `pfd` | Print the path of the frontmost Finder window |
| `pfs` | Print selected item paths in Finder |
| `cdf` | `cd` to frontmost Finder window path |
| `pushdf` | `pushd` to frontmost Finder window path |
| `man-preview [topic]` | Open rendered man page in Preview.app |
