export ZSH="$HOME/.oh-my-zsh"

export EDITOR='nvim'

ZSH_THEME=""

DISABLE_AUTO_TITLE="true"

#path
if [ -d "$HOME/.bin" ] ;
  then PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

#plugins
plugins=(git nvm)

# Completion system
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

source $ZSH/oh-my-zsh.sh

#zsh
alias reload="source ~/.zshrc"

# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# completion using vim keys
bindkey '^k' history-search-backward
bindkey '^j' history-search-forward

# Source zsh plugins (OS-aware paths)
if [[ "$OSTYPE" == "darwin"* ]]; then
  BREW_PREFIX=$(brew --prefix)
  source $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -d /usr/share/zsh/plugins ]]; then
  # Arch
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -d /usr/share/zsh-autosuggestions ]]; then
  # Debian/Fedora
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# tmux - start/attach session named after current directory with default windows
nic() {
  local session="$(basename "$PWD")"
  if command tmux has-session -t "$session" 2>/dev/null; then
    command tmux attach-session -t "$session"
  else
    command tmux new-session -d -s "$session" -n nvim
    command tmux send-keys -t "$session:1" nvim Enter
    command tmux new-window -t "$session" -n terminal
    command tmux new-window -t "$session" -n opencode
    command tmux send-keys -t "$session:3" opencode Enter
    command tmux new-window -t "$session" -n lazygit
    command tmux send-keys -t "$session:4" lazygit Enter
    command tmux select-window -t "$session:1"
    command tmux attach-session -t "$session"
  fi
}

# Alias / keyboard shortcuts
alias cd="z"
alias ls="eza --icons=always"

eval "$(zoxide init zsh)"

#starship settings
export STARSHIP_CONFIG=~/dots/starship.toml
eval "$(starship init zsh)"

# fzf
source <(fzf --zsh)

#nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# sst
export PATH=$HOME/.sst/bin:$PATH

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# opencode
export PATH=$HOME/.opencode/bin:$PATH

# pnpm
if [[ "$OSTYPE" == "darwin"* ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
else
  export PNPM_HOME="$HOME/.local/share/pnpm"
fi
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# bob (neovim version manager)
[ -f "$HOME/.local/share/bob/env/env.sh" ] && . "$HOME/.local/share/bob/env/env.sh"
