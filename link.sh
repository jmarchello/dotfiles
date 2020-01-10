# VIM
# ln -sfhiv ~/dotfiles/vim/.vimrc ~
# ln -sfhiv ~/dotfiles/vim/.vim ~
# ln -sfhiv ~/dotfiles/nvim ~/.config/

# NVIM
# ln -sfhiv ~/dotfiles/vim/.vim ${XDG_CONFIG_HOME:-~\/\.config}/nvim
# ln -sfhiv ~/dotfiles/vim/.vimrc ${XDG_CONFIG_HOME:-~\/\.config}/nvim/init.vim

# Tmux
# ln -sfiv ~/dotfiles/tmux/.tmux.conf ~

# ZSH
ln -sfhiv ~/dotfiles/zsh/.zshrc ~
mkdir ~/.oh-my-zsh/custom/josh
ln -sfFhiv ~/dotfiles/zsh/custom/* ~/.oh-my-zsh/custom/josh
