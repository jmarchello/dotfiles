cd ~/dotfiles

# VIM
ln -sfiv ./vim/.vimrc ~/
mv ~/.vim ~/.old_vim
ln -sfiv ./vim/.vim ~/

# Tmux
ln -sfiv ./tmux/.tmux.conf ~/

# ZSH
ln -sfiv ./zsh/.zshrc ~/
mv ~/.oh-my-zsh/custom ~/.oh-my-zsh/old_custom
ln -sfiv ./zsh/custom ~/.oh-my-zsh
