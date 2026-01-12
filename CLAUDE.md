# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a GNU Stow-managed dotfiles repository containing configurations for shell, editors, development tools, and productivity applications across macOS and Linux.

## Commands

### Deploying Configurations

```bash
# Deploy a specific tool's configuration (creates symlinks to $HOME)
stow <directory-name>

# Examples
stow vim      # Deploy vim config
stow nvim     # Deploy neovim config
stow zsh      # Deploy zsh config
stow git      # Deploy git config

# Remove a deployed configuration
stow -D <directory-name>
```

### Package Management

```bash
# Install Homebrew packages from Brewfile
brew bundle --file=homebrew/Brewfile

# Update Brewfile with currently installed packages
brew bundle dump --file=homebrew/Brewfile --force
```

## Architecture

### Directory Structure

Each top-level directory corresponds to one application and mirrors the structure it should have relative to `$HOME`. Stow creates symlinks maintaining this structure.

```
dotfiles/
├── vim/           → .vimrc symlinked to ~/.vimrc
├── nvim/          → .config/nvim/ symlinked to ~/.config/nvim/
├── git/           → .gitconfig, .gitmessage, .config/git/ symlinked
├── zsh/           → .zshrc symlinked to ~/.zshrc
├── tmux/          → .tmux.conf symlinked
└── ...
```

### Key Configuration Files

| Directory | Purpose |
|-----------|---------|
| `nvim/` | LazyVim-based Neovim config (Lua). Plugins in `lua/plugins/`, options in `lua/config/` |
| `vim/` | Traditional Vim config with FZF, NERDTree, ALE |
| `zsh/` | Oh-My-Zsh config with Starship prompt, FZF integration, platform-aware paths |
| `git/` | Git config with difftastic, GPG signing, global ignore patterns |
| `tmux/` | Tmux with TPM plugins (resurrect, continuum, yank) |
| `homebrew/` | Brewfile with all managed packages |
| `claude/` | Claude Code hooks for Clojure paren repair and cljfmt |

### Neovim Plugin Architecture

The Neovim config uses LazyVim with modular plugin files in `nvim/.config/nvim/lua/plugins/`. Each file exports a table of plugin specs loaded by lazy.nvim.

### Claude Code Hooks

The `claude/settings.json` configures hooks that run `clj-paren-repair-claude-hook --cljfmt` on Write/Edit operations for Clojure files. This requires the `clj-paren-repair-claude-hook` tool to be installed globally.

## Platform Notes

- Shell configs detect Linux vs macOS and adjust paths accordingly
- Homebrew paths differ: `/opt/homebrew` (Apple Silicon) vs `/home/linuxbrew/.linuxbrew` (Linux)
- NVM is lazy-loaded in zshrc for faster shell startup
