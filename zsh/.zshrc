# zsh options
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY
export HISTFILE=~/.zsh_history
export HISTFILESIZE=100000
export HISTSIZE=100000
setopt auto_cd # cd by typing directory name if it's not a command
setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt always_to_end # move cursor to end if word had one match
zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion
# end zsh options

# Prompt config
setopt PROMPT_SUBST
precmd() { print -rP '%(?.%F{green}√.%F{red}?) %F{white}%2~%F{cyan}$(__git_ps1 " (%s)") ' }
PROMPT='%F{yello}# '
. $HOME/.zsh/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
# end prompt config

# cache compinit daily
autoload -Uz compinit
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi
# end cache compinit

export EDITOR=vim
stty erase '^?'

# export TERM="xterm-256color"
#
#python debugging with pudb instead of pdb
export PYTHONBREAKPOINT=pudb.set_trace

# On linux, remap caps lock to control
if command -v setxkbmap &> /dev/null
then
  /usr/bin/setxkbmap -option "ctrl:nocaps"
fi

# PATH modification
PATH=/opt/local/bin:$PATH
export PATH="$HOME/.cargo/bin:$PATH"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
export PATH="/usr/local/share/dotnet:$PATH"
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.ebcli-virtual-env/executables:$PATH"


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

. $HOME/.zsh/aliases.zsh

# Plugins
. $HOME/.zsh/vendor/zsh-z/zsh-z.plugin.zsh
. $HOME/.zsh/vendor/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
. $HOME/.zsh/vendor/zsh-history-substring-search/zsh-history-substring-search.zsh
if [ -f $HOME/.zsh/local/init.sh ]; then
  . $HOME/.zsh/local/init.sh
fi

# bindkey "$terminfo[kcuu1]" history-substring-search-up
# bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down


if command -v kubectl &> /dev/null
then
  source <(kubectl completion zsh)
fi
