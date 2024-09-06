export ZSH="$HOME/.oh-my-zsh"

export TERM=xterm

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

#plugins
plugins=(git fzf)

source $ZSH/oh-my-zsh.sh

#git
alias glog="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --branches"

# linux
#enable wifi
alias wifi_on="sudo rfkill unblock wifi && sudo ip link set wlo1 up"

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
