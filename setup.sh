#!/bin/bash

# Dotfiles Setup
# Works on macOS, Debian/Ubuntu, Arch, Fedora
#
# Usage:
#   ./setup.sh              Full install (CLI + desktop apps)
#   ./setup.sh --headless   CLI tools only (no desktop apps, for servers/SSH dev envs)

set -e

DOTS="$(cd "$(dirname "$0")" && pwd)"
LOG="/tmp/dots-setup.log"

# Log all output
exec > >(tee -a "$LOG") 2>&1

#-------------------------------------------------------------------------------
# Parse flags
#-------------------------------------------------------------------------------
HEADLESS=false

for arg in "$@"; do
  case $arg in
    --headless) HEADLESS=true ;;
    *) echo "Unknown flag: $arg"; exit 1 ;;
  esac
done

if $HEADLESS; then
  echo "=== Dotfiles Setup (headless) ==="
  echo "  Skipping desktop apps: ghostty, zen-browser"
else
  echo "=== Dotfiles Setup ==="
fi
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

# Detect architecture
ARCH=$(uname -m)
echo "Detected Arch: $ARCH"
echo ""

#-------------------------------------------------------------------------------
# Install ZSH + Oh My Zsh
#-------------------------------------------------------------------------------
echo "[1/4] Setting up ZSH..."

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
echo "[2/4] Installing packages..."

install_macos() {
  if ! command -v brew &> /dev/null; then
    echo "  Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Add neovim nightly tap
  brew tap neovim/neovim || true

  brew install \
    eza fzf zoxide starship fastfetch tmux git gh ripgrep fd bat go lua \
    zsh-autosuggestions zsh-syntax-highlighting \
    lazygit cloudflared

  # Neovim nightly
  brew install neovim --HEAD || brew upgrade neovim --fetch-HEAD || true

  # Desktop apps (skip in headless mode)
  if ! $HEADLESS; then
    echo "  Installing desktop apps..."
    brew install mole || true
    brew install --cask ghostty zen-browser || true
  fi
}

install_arch() {
  sudo pacman -Syu --noconfirm
  sudo pacman -S --noconfirm --needed \
    eza fzf zoxide starship fastfetch tmux git github-cli ripgrep fd bat go lua \
    zsh zsh-autosuggestions zsh-syntax-highlighting \
    lazygit cloudflared htop

  # Neovim nightly from AUR
  if command -v yay &> /dev/null; then
    yay -S --noconfirm neovim-nightly-bin || true
  elif command -v paru &> /dev/null; then
    paru -S --noconfirm neovim-nightly-bin || true
  else
    echo "  Install neovim-nightly-bin from AUR manually (needs yay/paru)"
    sudo pacman -S --noconfirm neovim
  fi

  # Desktop apps (skip in headless mode)
  if ! $HEADLESS; then
    echo "  Installing desktop apps..."
    if command -v yay &> /dev/null; then
      yay -S --noconfirm ghostty zen-browser-bin || true
    elif command -v paru &> /dev/null; then
      paru -S --noconfirm ghostty zen-browser-bin || true
    fi
  fi
}

install_debian() {
  sudo apt update && sudo apt upgrade -y
  sudo apt install -y \
    fastfetch fzf tmux git gh ripgrep fd-find bat golang lua5.4 zsh curl build-essential htop

  # Neovim nightly
  if ! command -v nvim &> /dev/null; then
    echo "  Installing Neovim nightly..."
    case $ARCH in
      aarch64|arm64) NVIM_ARCHIVE="nvim-linux-arm64.tar.gz" ;;
      *) NVIM_ARCHIVE="nvim-linux-x86_64.tar.gz" ;;
    esac
    curl -LO "https://github.com/neovim/neovim/releases/download/nightly/$NVIM_ARCHIVE"
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf "$NVIM_ARCHIVE"
    sudo ln -sf /opt/nvim-linux-*/bin/nvim /usr/local/bin/nvim
    rm "$NVIM_ARCHIVE"
  fi

  # Tools not in apt
  command -v starship &> /dev/null || curl -sS https://starship.rs/install.sh | sh -s -- -y
  command -v zoxide &> /dev/null || curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  command -v eza &> /dev/null || cargo install eza 2>/dev/null || echo "  Install eza: cargo install eza"
  command -v lazygit &> /dev/null || go install github.com/jesseduffield/lazygit@latest 2>/dev/null || true

  # Cloudflared
  if ! command -v cloudflared &> /dev/null; then
    sudo mkdir -p --mode=0755 /usr/share/keyrings
    curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg > /dev/null
    echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflared.list
    sudo apt update
    sudo apt install -y cloudflared
  fi
}

install_fedora() {
  sudo dnf upgrade -y
  sudo dnf install -y \
    eza fzf zoxide fastfetch tmux git gh ripgrep fd-find bat golang lua zsh \
    zsh-autosuggestions zsh-syntax-highlighting lazygit htop

  # Neovim nightly
  sudo dnf copr enable agriffis/neovim-nightly -y || true
  sudo dnf install -y neovim || true

  command -v starship &> /dev/null || curl -sS https://starship.rs/install.sh | sh -s -- -y

  # Cloudflared
  if ! command -v cloudflared &> /dev/null; then
    sudo rpm --import https://pkg.cloudflare.com/cloudflare-main.gpg
    curl -fsSL https://pkg.cloudflare.com/cloudflared-ascii.repo | sudo tee /etc/yum.repos.d/cloudflared.repo
    sudo dnf install -y cloudflared
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
echo "[3/4] Installing NVM + Node..."

if [[ ! -d "$HOME/.nvm" ]]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install node || true
nvm install --lts || true
nvm use --lts || true

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
echo "[4/4] Creating symlinks..."

mkdir -p "$HOME/.config"

# Home directory
ln -sf "$DOTS/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTS/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTS/.gitconfig" "$HOME/.gitconfig"

# XDG config
ln -sfn "$DOTS/nvim" "$HOME/.config/nvim"
ln -sfn "$DOTS/fastfetch" "$HOME/.config/fastfetch"
ln -sfn "$DOTS/opencode" "$HOME/.config/opencode"
ln -sf "$DOTS/starship.toml" "$HOME/.config/starship.toml"

# Desktop app configs (skip in headless mode)
if ! $HEADLESS; then
  ln -sfn "$DOTS/ghostty" "$HOME/.config/ghostty"
fi

echo "  Symlinks created"

# Install TPM (Tmux Plugin Manager)
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  echo "  Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

#-------------------------------------------------------------------------------
# Done
#-------------------------------------------------------------------------------
echo ""
echo "=== Setup complete! ==="
echo ""
echo "Installed:"
echo "  • Shell: zsh, oh-my-zsh, starship"
echo "  • Editor: neovim (nightly)"
if ! $HEADLESS; then
  echo "  • Terminal: ghostty"
  echo "  • Browser: zen-browser"
fi
echo "  • CLI: eza, fzf, zoxide, tmux, ripgrep, fd, bat, lazygit"
echo "  • Runtime: nvm, node, bun, go, lua"
echo "  • Tools: cloudflared, opencode"
if $HEADLESS; then
  echo ""
  echo "  (headless mode — desktop apps skipped)"
fi

echo ""
echo "Log saved to: $LOG"
echo "Restart your terminal or run: source ~/.zshrc"
