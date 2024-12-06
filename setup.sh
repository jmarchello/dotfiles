# VIM
# ln -sfiv ~/dotfiles/vim/.vimrc ~
# rm -rf ~/.vim
# ln -sfiv ~/dotfiles/vim/.vim ~

# NVIM
# ln -sfiv ~/dotfiles/nvim ${XDG_CONFIG_HOME:-~\/\.config}

# Tmux
# ln -sfiv ~/dotfiles/tmux/.tmux.conf ~

# SHELL
ln -sfiv ~/dotfiles/shell/shell ~

# GIT
ln -sfiv ~/dotfiles/git/.gitignore_global ~
ln -sfiv ~/dotfiles/git/.gitconfig ~
# ln -sfiv ~/dotfiles/git/git-heatmap/git-heatmap ~/.local/bin
git config --global core.excludesfile '~/.gitignore_global'

# Sublime Text
# rm -rf ~/Library/Application\ Support/Sublime\ Text/Packages/User
# ln -sfiv ~/dotfiles/subl/User ~/Library/Application\ Support/Sublime\ Text/Packages

# bin
ln -sfiv ~/dotfiles/bin ~/bin

# Alacritty
# ln -sfiv ~/dotfiles/.alacritty.toml ~
