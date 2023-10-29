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
plugins=(git)

source $ZSH/oh-my-zsh.sh

alias vpn_ca="protonvpn-cli connect IS-CA#1"
alias vpn_de="protonvpn-cli connect CH-DE#1"
alias vpn_fr="protonvpn-cli connect CH-FR#1"
alias vpn_jp="protonvpn-cli connect CH-JP#1"
alias vpn_nl="protonvpn-cli connect CH-NL#1"

#exa
alias ls="exa -l -g --icons"
alias la="exa -l -a -g --icons"
alias llt="exa -1 --icons --tree --git-ignore"

#git
alias clone="git clone"
alias ga="git add"
alias gall="git add ."
alias gc="git commit -m"
alias gd="git diff"
alias gi="git init"
alias ic='git commit -m "chore(init): initial commit"'
alias gp="git push"
alias gpm="git push -u origin main"
alias gs="git status"
alias glog="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --branches"

#tmux
alias dev="tmux attach-session -t dev"
alias sdev="tmux new -s dev"

#enable wifi
alias wifi_on="sudo rfkill unblock wifi && sudo ip link set wlo1 up"

#starship settings
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/dots/starship.toml

#golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# fnm
export PATH="/home/bachitter/.local/share/fnm:$PATH"
eval "`fnm env`"

# bun completions
[ -s "/home/bachitter/.bun/_bun" ] && source "/home/bachitter/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="/home/bachitter/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
# Turso
export PATH="/home/bachitter/.turso:$PATH"
