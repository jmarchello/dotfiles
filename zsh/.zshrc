# zsh options
export HISTFILE=~/.zsh_history
export SAVEHIST=10000
export HISTFILESIZE=10000
export HISTSIZE=10000
setopt HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt auto_cd # cd by typing directory name if it's not a command
setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt always_to_end # move cursor to end if word had one match
zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion
# end zsh options

. $HOME/.zsh/prompt.zsh

# cache compinit daily
autoload -Uz compinit
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi
# end cache compinit

export EDITOR=nvim
stty erase '^?'

#GPG TTY
GPG_TTY=$(tty)
export GPG_TTY

#Git
export REVIEW_BASE=main

# export TERM="xterm-256color"
#
#python debugging with pudb instead of pdb
export PYTHONBREAKPOINT=pudb.set_trace

# On linux, remap caps lock to control
if command -v setxkbmap &> /dev/null
then
  /usr/bin/setxkbmap -option "ctrl:nocaps"
fi

# pyenv
if command -v pyenv &> /dev/null
then
  eval "$(pyenv init -)"
fi

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# initialise completions with ZSH's compinit
autoload -Uz compinit
compinit

if command -v jj &> /dev/null
then
  source <(jj util completion --zsh)
fi

. $HOME/.zsh/aliases.zsh

# Plugins
. $HOME/.zsh/vendor/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
if [ -f $HOME/.zsh/local/init.sh ]; then
  . $HOME/.zsh/local/init.sh
fi

if command -v kubectl &> /dev/null
then
  source <(kubectl completion zsh)
  export KUBE_EDITOR="nvim"
fi

#Homebrew
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval $(/opt/homebrew/bin/brew shellenv)

# PATH modification
export PATH="/usr/local/bin:${PATH}"
export PATH=/opt/local/bin:$PATH
export PATH="$HOME/.cargo/bin:$PATH"
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin
export PATH="/usr/local/share/dotnet:$PATH"
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/14/bin
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="./bin:$PATH"

# CDPATH
export CDPATH=.:~
export CDPATH=${CDPATH}:~/dev
export CDPATH=${CDPATH}:..

# rbenv
if command -v rbenv &> /dev/null
then
  eval "$(rbenv init - zsh)"
fi
