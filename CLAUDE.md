# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository for configuring development environments across Linux and macOS systems. Uses Ansible roles for automated configuration management.

## Common Commands

### Apply all configurations
```bash
cd ansible && ansible-playbook site.yml
```

### Apply a specific role only
```bash
cd ansible && ansible-playbook site.yml --tags <role-name>
```

Available role tags: shell, git, vim, bin, tmux, shell_tools, alacritty, sublime, neovim, helix, starship, dev_tools

## Architecture

### Ansible-Based Configuration
The repository uses Ansible roles (in `ansible/roles/`) to manage dotfile symlinks and tool installations. The main playbook is `ansible/site.yml` which orchestrates all roles against localhost.

Each role typically:
1. Creates necessary directories
2. Symlinks configuration files from this repo to their expected locations (usually `~/.config/` or `~/`)
3. Installs packages when needed (using apt on Debian, homebrew on macOS)

### Directory Structure Pattern
Configuration for each tool lives in its own directory:
- `vim/` → Vim configuration (`.vimrc` in Vim9script format)
- `nvim/` → Neovim configuration (Lua-based)
- `lazyvim/nvim/` → LazyVim starter configuration (symlinked as primary nvim config)
- `shell/` → Shared shell configuration sourced by both bash and zsh
- `zsh/` and `bash/` → Shell-specific rc files
- `tmux/`, `alacritty/`, `starship/`, `helix/`, `subl/`, `git/` → Tool-specific configs

### Shell Configuration
The `shell/` directory contains shared configuration:
- `shell/aliases.sh` - Command aliases
- `shell/vars.sh` - Environment variables (sets EDITOR to Sublime Text)
- `shell/prompt.sh` - Prompt configuration

Shell rc files (`zsh/rc`, `bash/rc`) source the shared `shell/` directory.

### Multi-Editor Setup
- **Primary**: Sublime Text (`subl/User/` contains settings, snippets, keybindings)
- **Secondary**: Vim (`.vimrc` uses Vim9script)
- **Tertiary**: Neovim (LazyVim configuration)
