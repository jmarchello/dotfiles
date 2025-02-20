shell:
	ln -sfv ./shell/shell ~
	(
	  if [[ "$SHELL" == *zsh*]]; then
	    echo "installing zshrc"
	    ln -sfv ./zsh/rc ~/.zshrc
	  else
	    echo "installing bashrc"
	    ln -sfv ./bash/rc ~/.bashrc
	  fi
	)
alacritty:
	(
	  if [[ command -v brew > /dev/null]]; then
	    brew install --cask alacritty
	    ln -sfv ./alacritty/alacritty.toml ~/.config/.alacritty.toml
	  else
	    echo "skipping alacritty"
	  fi
	)

git:
	ln -sfv ./git/.gitignore_global ~
	ln -sfv ./git/.gitconfig ~

vim:
	ln -sfv ./vim/.vimrc ~

bin:
	ls -sfv ./bin ~


