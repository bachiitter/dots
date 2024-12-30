# Shell integration

if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
  source $GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration
fi

export ZSH="$HOME/.oh-my-zsh"

export TERM=xterm-256color

#editor/term
export VISUAL="nvim"
export EDITOR="nvim"

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

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi"

#plugins
plugins=(git fzf nvm)

source $ZSH/oh-my-zsh.sh

#git
alias ga="git add"
alias gc="git commit"
alias gco="git checkout"
alias gp="git push"
alias gs="git status"
alias glog="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --branches"

alias web="cd ~/personal/portfolio && tmux new -s web"
alias sweb="tmux attach-session -t web"

alias bmrks="cd ~/analog/bookmarks && tmux new -s bmrks"
alias sbmrks="tmux attach-session -t bmrks"

alias cms="cd ~/analog/cms && tmux new -s cms"
alias scms="tmux attach-session -t cms"


# linux
#enable wifi
alias wifi_on="sudo rfkill unblock wifi && sudo ip link set wlo1 up"

#alias tmux='TERM=xterm-256color tmux'

#starship settings
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/dots/starship.toml

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
