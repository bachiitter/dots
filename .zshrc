export ZSH="$HOME/.oh-my-zsh"

#editor/term
export VISUAL="nvim"
export EDITOR="nvim"

ZSH_THEME=""

#path
if [ -d "$HOME/.bin" ] ;
  then PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

#plugins
plugins=(git fzf zsh-exa)

source $ZSH/oh-my-zsh.sh

#exa
alias ls="exa -l -g --icons"
alias la="exa -l -a -g --icons"
alias llt="exa -1 --icons --tree --git-ignore"

# linux
#enable wifi
alias wifi_on="sudo rfkill unblock wifi && sudo ip link set wlo1 up"

#starship settings
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/dots/starship.toml

#golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
