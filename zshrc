# ~/.zshrc — shared between macOS and Debian (managed by dotbot)

# ---------------------------------------------------------------------------
# PATH
# ---------------------------------------------------------------------------
# Homebrew (macOS: Apple Silicon or Intel)
for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  [[ -x $brew_bin ]] && eval "$($brew_bin shellenv)" && break
done
unset brew_bin

# User-installed binaries (starship, etc.) — ~/.profile isn't read by zsh
export PATH="$HOME/.local/bin:$PATH"
typeset -U path PATH   # drop duplicate PATH entries

# ---------------------------------------------------------------------------
# OS-specific settings
# ---------------------------------------------------------------------------
case "$OSTYPE" in
  darwin*)
    # Prefer GNU ls (brew install coreutils) so LS_COLORS/vivid work like Linux
    if command -v gls >/dev/null; then
      alias ls='gls --color=auto'
    else
      alias ls='ls -G'
    fi
    ;;
  linux*)
    alias ls='ls --color=auto'
    # libvirt: manage system VMs without -c qemu:///system
    command -v virsh >/dev/null && export LIBVIRT_DEFAULT_URI=qemu:///system
    ;;
esac

# ---------------------------------------------------------------------------
# Colors
# ---------------------------------------------------------------------------
if command -v vivid >/dev/null; then
  export LS_COLORS="$(vivid generate ayu)"
fi

# ---------------------------------------------------------------------------
# Aliases
# ---------------------------------------------------------------------------
alias ll='ls -al'
alias la='ls -a'

[[ -d ~/Documents/codjo ]] && alias cdp='cd ~/Documents/codjo'

if command -v docker >/dev/null; then
  alias dcp='docker compose --env-file ~/docker/.env -f ~/docker/docker-compose.yml'
fi

# ---------------------------------------------------------------------------
# Completion
# ---------------------------------------------------------------------------
autoload -Uz compinit
compinit -d ~/.zsh/.zcompdump

zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'  # case-insensitive
zstyle ':completion:*' menu select                                                 # arrow-key menu
[[ -n $LS_COLORS ]] && zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}       # colored matches

# ---------------------------------------------------------------------------
# History
# ---------------------------------------------------------------------------
[[ -d ~/.zsh ]] || mkdir -p ~/.zsh
HISTFILE=~/.zsh/.histfile
HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_HISTORY        # save timestamps and durations
setopt HIST_EXPIRE_DUPS_FIRST  # trim duplicates first when the file is full
setopt HIST_IGNORE_ALL_DUPS    # drop older copies of a repeated command
setopt HIST_FIND_NO_DUPS       # don't show duplicates when searching
setopt HIST_IGNORE_SPACE       # commands starting with a space aren't saved
setopt HIST_SAVE_NO_DUPS       # don't write duplicates to the file
setopt SHARE_HISTORY           # share history across open terminals

# Up/Down search history for commands starting with what you've typed.
# Both escape sequences are bound so it works in every terminal.
bindkey '^[[A' history-search-backward
bindkey '^[OA' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[OB' history-search-forward

# ---------------------------------------------------------------------------
# Machine-specific overrides (not in git)
# ---------------------------------------------------------------------------
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# ---------------------------------------------------------------------------
# Prompt (last, so nothing above overrides it)
# ---------------------------------------------------------------------------
if command -v starship >/dev/null; then
  eval "$(starship init zsh)"
else
  PROMPT='%B%F{202}%2~%b%f %(!,>>,>) '
fi
