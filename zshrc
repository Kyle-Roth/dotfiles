# ZSH prompt setup
PROMPT='%B%F{202}%2~%b%f %(!,>>,>) '
#export PS1='%B%F{202}%2~%b%f %(!,>>,>) '

# ALIASs for use in terminal
alias cdp='cd ~/Documents/codjo'
alias ls='ls --color=auto'
alias ll='ls -al'
alias la='ls -a'

# ZSH tab completion system
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle :compinstall filename 'Users/kyleroth/.zshrc'

autoload -Uz compinit
compinit
# End of lines for CompInstall

# CMD line history stuff
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS

# Load the Zsh functions for smarter up/down history search
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search

# Make them available as ZLE (Zsh Line Editor) widgets
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Bind the up arrow to search backward through history 
# for commands that match the current typed prefix
bindkey "^[[A" up-line-or-beginning-search   # Up arrow key

# Bind the down arrow to search forward through matching history
bindkey "^[[B" down-line-or-beginning-search # Down arrow key

# setting ls colors
export LS_COLOR="$(vivid generate ayu)"
