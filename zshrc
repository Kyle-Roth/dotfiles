# ZSH prompt setup
#PROMPT='%B%F{202}%2~%b%f %(!,>>,>) '
#export PS1='%B%F{202}%2~%b%f %(!,>>,>) '
# setting zsh theme
eval "$(starship init zsh)"

# ALIASs for use in terminal
alias cdp='cd ~/Documents/codjo'
alias ls='ls --color=auto'
alias ll='ls -al'
alias la='ls -a'

# Docker Alias
alias dcp='docker compose --env-file ~/docker/.env -f ~/docker/docker-compose.yml'

# ZSH tab completion system
#zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
#zstyle :compinstall filename 'Users/kyleroth/.zshrc'

#autoload -Uz compinit
#compinit
# End of lines for CompInstall

# CMD line history stuff
HISTFILE=~/.zsh/.histfile
HISTSIZE=50000
SAVEHIST=20000

setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt SHARE_HISTORY             # Share history between all sessions.
# end HISTORY

# smarter command search with arrow keys
bindkey "^[[A" history-search-backward # Up arrow key
bindkey "^[[B" history-search-forward # Down arrow key

# setting ls colors
export LS_COLOR="$(vivid generate ayu)"
