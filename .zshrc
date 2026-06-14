export EDITOR='nvim'

DISABLE_AUTO_TITLE="true"

#path
if [ -d "$HOME/.bin" ] ;
  then PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

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
#

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

killport() {
  local port="$1"

  if [ -z "$port" ]; then
    echo "usage: killport <port>"
    return 1
  fi

  local pids
  pids="$(lsof -ti :"$port")"

  if [ -z "$pids" ]; then
    echo "nothing is using port $port"
    return 0
  fi

  echo "stopping process(es) on port $port: $pids"
  kill $pids

  sleep 1

  local remaining
  remaining="$(lsof -ti :"$port")"
  if [ -n "$remaining" ]; then
    echo "force killing remaining process(es): $remaining"
    kill -9 $remaining
  fi
}

killds() {
  killport "${1:-4983}"
}

# Alias / keyboard shortcuts
alias bun="pnpm"
alias cd="z"
alias ls="eza --icons=always"

eval "$(zoxide init zsh)"

autoload -Uz colors vcs_info
colors

zstyle ':vcs_info:git:*' formats ' %b '
zstyle ':vcs_info:*' enable git

precmd() {
  vcs_info
}

prompt_hostname() {
  [[ -n "$SSH_CONNECTION" ]] && print -n "%F{green}%m%f "
}

prompt_username() {
  [[ -n "$SSH_CONNECTION" ]] && print -n "%F{yellow}%n%f@"
}

setopt PROMPT_SUBST

PROMPT='%F{white}%f %F{blue}%~%f %F{purple}${vcs_info_msg_0_}%f$(prompt_hostname)$(prompt_username)'

# fzf
source <(fzf --zsh)

#golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

export PATH="/opt/homebrew/bin:$PATH"

# sst
export PATH=$HOME/.sst/bin:$PATH

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
# fnm
eval "$(fnm env --use-on-cd --shell zsh)"
