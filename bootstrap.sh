sudo pacman -Syu --noconfirm
sudo pacman -Sy --noconfirm github-cli git neovim tmux zsh make ruby clang postgresql nodejs npm yarn

sudo cp -r /vagrant ./dotfiles
sudo chown -R vagrant:vagrant ./dotfiles
mkdir -p ./.local/bin

# LUNARVIM
bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) --no-install-dependencies

ln -sfiv ./dotfiles/lunarvim/config.lua ./.config/lvim

# Tmux
ln -sfiv ./dotfiles/tmux/.tmux.conf .

# ZSH
ln -sfiv ./dotfiles/zsh/.zshrc .
ln -sfiv ./dotfiles/zsh/.zsh .
sudo chsh -s /bin/zsh vagrant

# GIT
ln -sfiv ./dotfiles/git/.gitignore_global .
ln -sfiv ./dotfiles/git/.gitconfig .
ln -sfiv ./dotfiles/git/git-heatmap/git-heatmap ./.local/bin
git config --global core.excludesfile './.gitignore_global'

