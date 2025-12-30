#!/bin/bash

# Dotfiles Setup
# Works on macOS, Debian/Ubuntu, Arch, Fedora

set -e

DOTS="$(cd "$(dirname "$0")" && pwd)"

echo "=== Dotfiles Setup ==="
echo ""

#-------------------------------------------------------------------------------
# Detect OS
#-------------------------------------------------------------------------------
detect_os() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macos"
  elif [[ -f /etc/arch-release ]]; then
    echo "arch"
  elif [[ -f /etc/debian_version ]]; then
    echo "debian"
  elif [[ -f /etc/fedora-release ]]; then
    echo "fedora"
  else
    echo "unknown"
  fi
}

OS=$(detect_os)
echo "Detected OS: $OS"
echo ""

#-------------------------------------------------------------------------------
# Install ZSH + Oh My Zsh
#-------------------------------------------------------------------------------
echo "[1/5] Setting up ZSH..."

install_zsh() {
  if ! command -v zsh &> /dev/null; then
    echo "  Installing ZSH..."
    case $OS in
      macos) brew install zsh ;;
      arch) sudo pacman -S --noconfirm zsh ;;
      debian) sudo apt install -y zsh ;;
      fedora) sudo dnf install -y zsh ;;
    esac
  fi

  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "  Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi

  # Set ZSH as default shell
  if [[ "$SHELL" != *"zsh"* ]]; then
    chsh -s "$(which zsh)" || echo "  Run manually: chsh -s \$(which zsh)"
  fi
}

install_zsh

#-------------------------------------------------------------------------------
# Install packages
#-------------------------------------------------------------------------------
echo ""
echo "[2/5] Installing packages..."

install_macos() {
  if ! command -v brew &> /dev/null; then
    echo "  Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Add neovim nightly tap
  brew tap neovim/neovim || true

  brew install \
    eza fzf zoxide starship fastfetch tmux git gh ripgrep fd jq bat go lua \
    zsh-autosuggestions zsh-syntax-highlighting \
    lua-language-server stylua lazygit cloudflared

  # Neovim nightly
  brew install neovim --HEAD || brew upgrade neovim --fetch-HEAD || true

  # Casks
  brew install --cask font-jetbrains-mono-nerd-font ghostty || true
}

install_arch() {
  sudo pacman -Syu --noconfirm
  sudo pacman -S --noconfirm --needed \
    eza fzf zoxide starship fastfetch tmux git github-cli ripgrep fd jq bat go lua \
    zsh zsh-autosuggestions zsh-syntax-highlighting \
    lua-language-server stylua lazygit cloudflared ttf-jetbrains-mono-nerd

  # Neovim nightly from AUR
  if command -v yay &> /dev/null; then
    yay -S --noconfirm neovim-nightly-bin || true
  elif command -v paru &> /dev/null; then
    paru -S --noconfirm neovim-nightly-bin || true
  else
    echo "  Install neovim-nightly-bin from AUR manually (needs yay/paru)"
    sudo pacman -S --noconfirm neovim
  fi

  # Ghostty from AUR
  if command -v yay &> /dev/null; then
    yay -S --noconfirm ghostty || true
  elif command -v paru &> /dev/null; then
    paru -S --noconfirm ghostty || true
  fi
}

install_debian() {
  sudo apt update && sudo apt upgrade -y
  sudo apt install -y \
    fzf tmux git ripgrep fd-find jq bat golang lua5.4 zsh curl build-essential

  # Neovim nightly
  if ! command -v nvim &> /dev/null; then
    echo "  Installing Neovim nightly..."
    curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux64.tar.gz
    sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
    rm nvim-linux64.tar.gz
  fi

  # Tools not in apt
  command -v starship &> /dev/null || curl -sS https://starship.rs/install.sh | sh -s -- -y
  command -v zoxide &> /dev/null || curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  command -v eza &> /dev/null || cargo install eza 2>/dev/null || echo "  Install eza: cargo install eza"
  command -v lazygit &> /dev/null || go install github.com/jesseduffield/lazygit@latest 2>/dev/null || true

  # Cloudflared
  if ! command -v cloudflared &> /dev/null; then
    curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o /tmp/cloudflared.deb
    sudo dpkg -i /tmp/cloudflared.deb || true
    rm /tmp/cloudflared.deb
  fi
}

install_fedora() {
  sudo dnf upgrade -y
  sudo dnf install -y \
    eza fzf zoxide tmux git gh ripgrep fd-find jq bat golang lua zsh \
    zsh-autosuggestions zsh-syntax-highlighting lazygit

  # Neovim nightly
  sudo dnf copr enable agriffis/neovim-nightly -y || true
  sudo dnf install -y neovim || true

  command -v starship &> /dev/null || curl -sS https://starship.rs/install.sh | sh -s -- -y

  # Cloudflared
  if ! command -v cloudflared &> /dev/null; then
    curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-x86_64.rpm -o /tmp/cloudflared.rpm
    sudo rpm -i /tmp/cloudflared.rpm || true
    rm /tmp/cloudflared.rpm
  fi
}

case $OS in
  macos) install_macos ;;
  arch) install_arch ;;
  debian) install_debian ;;
  fedora) install_fedora ;;
  *) echo "Unknown OS. Install packages manually." ;;
esac

#-------------------------------------------------------------------------------
# Install NVM + Node
#-------------------------------------------------------------------------------
echo ""
echo "[3/5] Installing NVM + Node..."

if [[ ! -d "$HOME/.nvm" ]]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install node || true
nvm use node || true

# Bun
if ! command -v bun &> /dev/null; then
  echo "  Installing Bun..."
  curl -fsSL https://bun.sh/install | bash
fi

# Opencode
if ! command -v opencode &> /dev/null; then
  echo "  Installing Opencode..."
  curl -fsSL https://opencode.ai/install | bash || true
fi

#-------------------------------------------------------------------------------
# Create symlinks
#-------------------------------------------------------------------------------
echo ""
echo "[4/5] Creating symlinks..."

mkdir -p "$HOME/.config"

# Home directory
ln -sf "$DOTS/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTS/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTS/.gitconfig" "$HOME/.gitconfig"

# XDG config
ln -sf "$DOTS/nvim" "$HOME/.config/nvim"
ln -sf "$DOTS/ghostty" "$HOME/.config/ghostty"
ln -sf "$DOTS/fastfetch" "$HOME/.config/fastfetch"
ln -sf "$DOTS/starship.toml" "$HOME/.config/starship.toml"

echo "  Symlinks created"

#-------------------------------------------------------------------------------
# Install LSP servers & formatters
#-------------------------------------------------------------------------------
echo ""
echo "[5/5] Installing LSP servers..."

# Reload NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# npm packages
if command -v npm &> /dev/null; then
  npm install -g \
    @astrojs/language-server \
    @biomejs/biome \
    vscode-langservers-extracted \
    emmet-ls \
    @tailwindcss/language-server \
    @vtsls/language-server \
    2>/dev/null || true
fi

# Go tools
if command -v go &> /dev/null; then
  go install golang.org/x/tools/gopls@latest 2>/dev/null || true
  go install golang.org/x/tools/cmd/goimports@latest 2>/dev/null || true
  go install mvdan.cc/gofumpt@latest 2>/dev/null || true
fi

echo "  LSP servers installed"

#-------------------------------------------------------------------------------
# Done
#-------------------------------------------------------------------------------
echo ""
echo "=== Setup complete! ==="
echo ""
echo "Installed:"
echo "  • Shell: zsh, oh-my-zsh, starship"
echo "  • Editor: neovim (nightly)"
echo "  • Terminal: ghostty"
echo "  • CLI: eza, fzf, zoxide, tmux, ripgrep, fd, bat, lazygit"
echo "  • Runtime: nvm, node, bun, go, lua"
echo "  • Tools: cloudflared, opencode"
echo "  • LSP: astro, biome, cssls, emmet, gopls, jsonls, lua_ls, tailwindcss, vtsls"
echo "  • Formatters: biome, goimports, gofumpt, stylua"
echo ""
echo "Restart your terminal or run: source ~/.zshrc"
