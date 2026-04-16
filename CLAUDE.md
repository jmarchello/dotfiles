# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository for configuring development environments across Linux and macOS systems. Uses Ansible roles for automated configuration management.

## Common Commands

### Apply all configurations
```bash
cd ansible && ansible-playbook site.yml --ask-become-pass
```

### Apply a specific role only
```bash
cd ansible && ansible-playbook site.yml --tags <role-name> --ask-become-pass
```

Available role tags: shell, git, vim, bin, tmux, shell_tools, alacritty, sublime, sublime_merge, neovim, helix, starship, dev_tools

## Architecture

### Ansible-Based Configuration
The repository uses Ansible roles (in `ansible/roles/`) to manage dotfile symlinks and tool installations. The main playbook is `ansible/site.yml` which orchestrates all roles against localhost.

Each role typically:
1. Creates necessary directories
2. Symlinks configuration files from this repo to their expected locations (usually `~/.config/` or `~/`)
3. Installs packages when needed (using apt on Debian, homebrew on macOS)

### Directory Structure Pattern
Configuration for each tool lives in its own directory under `config/`:
- `config/vim/` → Vim configuration (`.vimrc` in Vim9script format)
- `config/nvim/` → Neovim configuration (Lua-based)
- `config/lazyvim/nvim/` → LazyVim starter configuration (symlinked as primary nvim config)
- `config/shell/` → Shared shell configuration sourced by both bash and zsh
- `config/zsh/` and `config/bash/` → Shell-specific rc files
- `config/tmux/`, `config/alacritty/`, `config/starship/`, `config/helix/`, `config/subl/`, `config/git/` → Tool-specific configs

### Shell Configuration
The `config/shell/` directory contains shared configuration:
- `config/shell/aliases.sh` - Command aliases
- `config/shell/vars.sh` - Environment variables (sets EDITOR to Sublime Text)
- `config/shell/prompt.sh` - Prompt configuration

Shell rc files (`config/zsh/rc`, `config/bash/rc`) source the shared `config/shell/` directory.

### Multi-Editor Setup
- **Primary**: Sublime Text (`config/subl/User/` contains settings, snippets, keybindings)
- **Secondary**: Vim (`.vimrc` uses Vim9script)
- **Tertiary**: Neovim (LazyVim configuration)
