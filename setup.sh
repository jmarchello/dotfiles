# VIM
#  ln -sfiv ~/dotfiles/vim/.vimrc ~
#  rm -rf ~/.vim
#  ln -sfiv ~/dotfiles/vim/.vim ~

# Tmux
#  ln -sfiv ~/dotfiles/tmux/.tmux.conf ~

# Homebrew
if command -v brew &> /dev/null
then
  brew bundle
fi

# ZSH
 ln -sfiv ~/dotfiles/zsh/.zshrc ~
 ln -sfiv ~/dotfiles/zsh/.zsh ~

# GIT
 ln -sfiv ~/dotfiles/git/.gitignore_global ~
 git config --global core.excludesfile '~/.gitignore_global'

# Kitty
# mkdir ~/.config/kitty
# ln -sfiv ~/dotfiles/kitty.conf ~/.config/kitty
