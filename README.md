# Dotfiles

Personal configuration files for macOS and Linux.

## Quick Start

```bash
git clone https://github.com/bachiitter/dots.git ~/dots
cd ~/dots
./setup.sh
```

### Headless (servers / SSH dev environments)

```bash
./setup.sh --headless
```

Skips desktop apps (Ghostty, Zen Browser) and their configs. Installs only CLI tools, runtimes, and shell setup — everything you need for a remote dev environment.

## What Gets Installed

### Shell
- **ZSH** with Oh My Zsh
- **Starship** prompt
- **zsh-autosuggestions** & **zsh-syntax-highlighting**

### Editor
- **Neovim** (nightly build)
- LSP servers: astro, biome, cssls, gopls, jsonls, lua_ls, tailwindcss, vtsls
- Formatters: biome, goimports, gofumpt, stylua

### Terminal
- **Ghostty**

### CLI Tools
| Tool | Description |
|------|-------------|
| eza | Modern `ls` replacement |
| fzf | Fuzzy finder |
| zoxide | Smarter `cd` |
| tmux | Terminal multiplexer |
| ripgrep | Fast grep |
| fd | Fast find |
| bat | Cat with syntax highlighting |
| lazygit | Git TUI |

### Runtimes & Languages
- **Node.js** via nvm
- **Bun**
- **Go**
- **Lua**

### Other Tools
- **cloudflared** - Cloudflare tunnel
- **opencode** - AI coding assistant

## Structure

```
dots/
├── nvim/              # Neovim config
│   ├── init.lua       # Main config
│   └── lsp/           # LSP server configs
├── ghostty/           # Ghostty terminal config
├── fastfetch/         # Fastfetch config
├── .zshrc             # ZSH config
├── .tmux.conf         # Tmux config
├── .gitconfig         # Git config
├── starship.toml      # Starship prompt
└── setup.sh           # Install script
```

## Symlinks Created

| Source | Destination |
|--------|-------------|
| `dots/.zshrc` | `~/.zshrc` |
| `dots/.tmux.conf` | `~/.tmux.conf` |
| `dots/.gitconfig` | `~/.gitconfig` |
| `dots/nvim` | `~/.config/nvim` |
| `dots/ghostty` | `~/.config/ghostty` | * |
| `dots/fastfetch` | `~/.config/fastfetch` |
| `dots/starship.toml` | `~/.config/starship.toml` |

\* Skipped in `--headless` mode

## Supported OS

- **macOS** (Homebrew)
- **Arch Linux** (pacman + AUR)
- **Debian/Ubuntu** (apt)
- **Fedora** (dnf)

## Manual Steps

After running `setup.sh`:

1. Restart your terminal or run `source ~/.zshrc`
2. Open Neovim - plugins will auto-install
3. Configure git:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your@email.com"
   ```

## Keybindings

### Neovim

| Key | Action |
|-----|--------|
| `<Space>` | Leader key |
| `<leader>sf` | Search files (git) |
| `<leader>sg` | Search grep |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename |
| `<leader>f` | Format |
| `<leader>-` | File explorer (Oil) |
| `gd` | Go to definition |
| `gr` | Go to references |

### Tmux

| Key | Action |
|-----|--------|
| `Ctrl-b h/j/k/l` | Navigate panes |
| `Ctrl-b "` | Split horizontal |
| `Ctrl-b %` | Split vertical |
| `Ctrl-b r` | Reload config |
