shell:
	ln -sfv ./shell/shell ~ && \
	if [[ "$SHELL" == *zsh* ]]; then \
	  echo "installing zshrc" && \
	  ln -sfv ~/dotfiles/zsh/rc ~/.zshrc; \
	else \
	  echo "installing bashrc" && \
	  ln -sfv ~/dotfiles/bash/rc ~/.bashrc; \
	fi
alacritty:
	if command -v brew > /dev/null; then \
	  brew install --cask alacritty && \
	  ln -sfv ~/dotfiles/alacritty/alacritty.toml ~/.config/.alacritty.toml; \
	else \
	  echo "skipping alacritty"; \
	fi

git:
	ln -sfv ~/dotfiles/git/.gitignore_global ~ && \
	ln -sfv ~/dotfiles/git/.gitconfig ~

vim:
	cd ./tmp && \
	git clone http://github.com/vim/vim.git && \
	cd vim/src && \
	(make install) && \
	cd ~/dotfiles && \
	rm -rf ./tmp/vim && \
	ln -sfv ~/dotfiles/vim/.vimrc ~

neovim:
	( \
		cd ~/Downloads && \
		curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz && \
		sudo tar -xzf nvim-linux-x86_64.tar.gz && \
		sudo rm -rf /opt/neovim && \
		sudo cp -r nvim-linux-x86_64 /opt/neovim \
	)

bin:
	ls -sfv ~/dotfiles/bin ~

tmux:
	ln -sfv ~/dotfiles/tmux/.tmux.conf ~

starship:
	ln -sfv ~/dotfiles/starship/starship.toml ~/.config

lazyvim:
	ln -sfv ~/dotfiles/lazyvim/nvim ~/.config


.PHONY: shell alacritty git vim bin tmux starship lazyvim neovim
