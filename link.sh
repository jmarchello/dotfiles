# VIM
ln -sfhiv ~/dotfiles/vim/.vimrc ~
ln -sfhiv ~/dotfiles/vim/.vim ~
ln -sfhiv ~/dotfiles/nvim ~/.config/

# Tmux
# ln -sfiv ~/dotfiles/tmux/.tmux.conf ~

# ZSH
ln -sfhiv ~/dotfiles/zsh/.zshrc ~
mkdir ~/.oh-my-zsh/custom/josh
ln -sfFhiv ~/dotfiles/zsh/custom/* ~/.oh-my-zsh/custom/josh
