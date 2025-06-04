export ZSH="$HOME/.oh-my-zsh"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

ZSH_THEME=""

#path
if [ -d "$HOME/.bin" ] ;
  then PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

#plugins
plugins=(git nvm)

source $ZSH/oh-my-zsh.sh

#zsh
alias reload="source ~/.zshrc"

#eza
alias ls="eza"
alias ll="eza -l -g --git"
alias llt="eza -1 --git --tree --git-ignore"

alias web="cd ~/personal/portfolio && tmux new -s web"
alias sweb="tmux attach-session -t web"

alias ui="cd ~/analog/orphos && tmux new -s orphos"
alias sui="tmux attach-session -t orphos"


alias bmrks="cd ~/analog/bookmarks && tmux new -s bmrks"
alias sbmrks="tmux attach-session -t bmrks"

alias cms="cd ~/analog/cms && tmux new -s cms"
alias scms="tmux attach-session -t cms"

alias gdt="cd ~/analog/digest && tmux new -s digest"
alias sgdt="tmux attach-session -t digest"


#alias tmux='TERM=xterm-256color tmux'

#starship settings
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/dots/starship.toml

# fzf
source <(fzf --zsh)

#nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

#golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# sst
export PATH=/home/bachitter/.sst/bin:$PATH

# bun completions
[ -s "/home/bachitter/.bun/_bun" ] && source "/home/bachitter/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
