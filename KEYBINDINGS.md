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

### Zsh (macOS only)

| Command | Action |
| ------- | ------ |
| `ofd` | Open current directory in Finder |
| `pfd` | Print the path of the frontmost Finder window |
| `pfs` | Print selected item paths in Finder |
| `cdf` | `cd` to frontmost Finder window path |
| `pushdf` | `pushd` to frontmost Finder window path |
| `man-preview [topic]` | Open rendered man page in Preview.app |
