# =============================================================================
# .zshrc — Zsh configuration
# =============================================================================

# --- Homebrew (must be first to set PATH) ------------------------------------
if [[ "$OSTYPE" == "darwin"* ]]; then
  for brew_path in /opt/homebrew/bin/brew /usr/local/bin/brew "$HOME/brew/bin/brew"; do
    if [[ -x "$brew_path" ]]; then
      eval "$("$brew_path" shellenv)"
      break
    fi
  done
fi

# --- History -----------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS       # don't record duplicate consecutive commands
setopt HIST_IGNORE_SPACE      # don't record commands starting with a space
setopt HIST_VERIFY            # show expanded history before running
setopt SHARE_HISTORY          # share history across sessions
setopt EXTENDED_HISTORY       # save timestamps

# --- Options -----------------------------------------------------------------
setopt AUTO_CD                # type a dir name to cd into it
setopt CORRECT                # suggest corrections for mistyped commands
setopt NO_CASE_GLOB           # case-insensitive globbing
setopt GLOB_DOTS              # include dotfiles in globbing
setopt EXTENDED_GLOB          # extended globbing patterns
setopt NO_BEEP                # silence all bells

# --- Auto-suggestions --------------------------------------------------------
if [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ -f "$HOME/brew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$HOME/brew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=240"

# --- Completion --------------------------------------------------------------
autoload -Uz compinit && compinit
setopt COMPLETE_IN_WORD       # complete from both ends of a word
setopt ALWAYS_TO_END          # move cursor to end after completion
setopt MENU_COMPLETE          # auto-select first completion match
zstyle ':completion:*' menu select                  # arrow-key menu
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# --- Key bindings ------------------------------------------------------------
bindkey -e                            # emacs key bindings (ctrl-a, ctrl-e, etc.)
bindkey '^[[A' history-search-backward   # up arrow: search history
bindkey '^[[B' history-search-forward    # down arrow: search history
bindkey '^[[H' beginning-of-line         # Home
bindkey '^[[F' end-of-line               # End
bindkey '^[[3~' delete-char              # Delete key
bindkey '^[[1;5C' forward-word           # ctrl+right
bindkey '^[[1;5D' backward-word          # ctrl+left

# --- Prompt ------------------------------------------------------------------
eval "$(starship init zsh)"

# --- Aliases -----------------------------------------------------------------
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias ls='ls -G'
  alias grep='grep --color=auto'
else
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias mkdir='mkdir -pv'
alias df='df -h'
alias du='du -h'
alias free='free -h'

# tmux shortcuts
alias ta='tmux -CC attach'
alias tl='tmux ls'

# git shortcuts
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias glog='git log --oneline --graph --decorate --all'

# safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias hsi='history | grep -i'

# --- Environment -------------------------------------------------------------
export EDITOR='nano'
export VISUAL='nano'
export PAGER='less'
export LESS='-R'             # pass color codes through in less
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# Preserve existing PATH additions
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# --- Functions ---------------------------------------------------------------

# Make a directory and cd into it
mkcd() { mkdir -p "$1" && cd "$1" }

# Extract any archive
extract() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2)  tar xjf "$1"  ;;
      *.tar.gz)   tar xzf "$1"  ;;
      *.tar.xz)   tar xJf "$1"  ;;
      *.tar)      tar xf  "$1"  ;;
      *.bz2)      bunzip2 "$1"  ;;
      *.gz)       gunzip  "$1"  ;;
      *.zip)      unzip   "$1"  ;;
      *.7z)       7z x    "$1"  ;;
      *.rar)      unrar x "$1"  ;;
      *)          echo "Unknown archive format: $1" ;;
    esac
  else
    echo "'$1' is not a file"
  fi
}

# Quick find by name
f() { find . -name "*$1*" 2>/dev/null }

# --- macOS Finder integration ------------------------------------------------
if [[ "$OSTYPE" == "darwin"* ]]; then
  # Open current directory in Finder
  ofd() { open . }

  # Return path of frontmost Finder window
  pfd() {
    osascript 2>/dev/null <<EOF
      tell application "Finder"
        return POSIX path of (target of first window as alias)
      end tell
EOF
  }

  # Return current Finder selection
  pfs() {
    osascript 2>/dev/null <<EOF
      tell application "Finder"
        set sel to (get selection)
        if sel is {} then return
        set paths to {}
        repeat with f in sel
          set end of paths to POSIX path of (f as alias)
        end repeat
        return paths
      end tell
EOF
  }

  # cd to current Finder directory
  cdf() { cd "$(pfd)" }

  # pushd to current Finder directory
  pushdf() { pushd "$(pfd)" }

  # Open man page in Preview
  man-preview() { man -t "$@" | open -f -a Preview }
fi


# =============================================================================
