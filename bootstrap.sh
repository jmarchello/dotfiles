pacman -Syu --noconfirm
echo 'installing packages'

pacman -Sy --noconfirm github-cli git neovim tmux zsh make

sudo su vagrant

cp -r /vagrant ~/dotfiles
mkdir -p ~/.config/lvim
mkdir -p ~/.local/bin

# LUNARVIM
ln -sfiv ~/dotfiles/lunarvim/config.lua ~/.config/lvim

# Tmux
ln -sfiv ~/dotfiles/tmux/.tmux.conf ~

# ZSH
ln -sfiv ~/dotfiles/zsh/.zshrc ~
ln -sfiv ~/dotfiles/zsh/.zsh ~
chsh -s /bin/zsh vagrant

# GIT
ln -sfiv ~/dotfiles/git/.gitignore_global ~
ln -sfiv ~/dotfiles/git/.gitconfig ~
ln -sfiv ~/dotfiles/git/git-heatmap/git-heatmap ~/.local/bin
git config --global core.excludesfile '~/.gitignore_global'
