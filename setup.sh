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
# Install ZSH
#-------------------------------------------------------------------------------
echo "[1/4] Setting up ZSH..."

install_zsh() {
  if ! command -v zsh &> /dev/null; then
    echo "  Installing ZSH..."
    case $OS in
      macos) brew install zsh || brew upgrade zsh ;;
      arch) sudo pacman -S --noconfirm zsh ;;
      debian) sudo apt install -y zsh ;;
      fedora) sudo dnf install -y zsh ;;
    esac
  elif [[ "$OS" == "macos" ]]; then
    brew upgrade zsh || true
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

  brew install \
    eza fzf zoxide fastfetch tmux git gh ripgrep fd bat go lua \
    lazygit cloudflared neovim fnm pnpm tree-sitter-cli

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
    base-devel eza fzf zoxide fastfetch tmux git github-cli ripgrep fd bat go lua \
    zsh lazygit cloudflared htop neovim fnm tree-sitter-cli

  if ! command -v yay &> /dev/null; then
    echo "  Installing yay..."
    yay_build_dir="$(mktemp -d)"
    git clone https://aur.archlinux.org/yay.git "$yay_build_dir/yay"
    (cd "$yay_build_dir/yay" && makepkg -si --noconfirm)
    rm -rf "$yay_build_dir"
  fi

  yay -S --noconfirm --needed pnpm-bin || true

  # Desktop apps (skip in headless mode)
  if ! $HEADLESS; then
    echo "  Installing desktop apps..."
    if command -v yay &> /dev/null; then
      yay -S --noconfirm ghostty zen-browser-bin || true
    fi
  fi
}

install_debian() {
  sudo apt update && sudo apt upgrade -y
  sudo apt install -y \
    fastfetch fzf tmux git gh ripgrep fd-find bat golang lua5.4 zsh curl build-essential htop neovim

  # Tools not in apt
  command -v zoxide &> /dev/null || curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  command -v eza &> /dev/null || cargo install eza 2>/dev/null || echo "  Install eza: cargo install eza"
  command -v lazygit &> /dev/null || go install github.com/jesseduffield/lazygit@latest 2>/dev/null || true
  command -v fnm &> /dev/null || curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
  command -v tree-sitter &> /dev/null || cargo install tree-sitter-cli 2>/dev/null || echo "  Install tree-sitter-cli: cargo install tree-sitter-cli"

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
    lazygit htop neovim fnm tree-sitter-cli

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
# Install FNM + Node
#-------------------------------------------------------------------------------
echo ""
echo "[3/4] Installing FNM + Node..."

if ! command -v fnm &> /dev/null; then
  curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
fi

export PATH="$HOME/.local/share/fnm:$PATH"
eval "$(fnm env --shell bash)"

fnm install --lts || true
fnm default lts-latest || true
fnm use lts-latest || true

# pnpm
if [[ "$OS" == "macos" ]]; then
  brew install pnpm || brew upgrade pnpm || true
elif ! command -v pnpm &> /dev/null; then
  corepack enable pnpm || true
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
echo "  • Shell: zsh"
echo "  • Editor: neovim"
if ! $HEADLESS; then
  echo "  • Terminal: ghostty"
  echo "  • Browser: zen-browser"
fi
echo "  • CLI: eza, fzf, zoxide, tmux, ripgrep, fd, bat, lazygit, tree-sitter-cli"
echo "  • Runtime: fnm, node LTS, pnpm, go, lua"
echo "  • Tools: cloudflared, opencode"
if $HEADLESS; then
  echo ""
  echo "  (headless mode — desktop apps skipped)"
fi

echo ""
echo "Log saved to: $LOG"
echo "Restart your terminal or run: source ~/.zshrc"
