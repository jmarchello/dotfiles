# zsh options
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
export HISTFILE=~/.zsh_history
export HISTFILESIZE=100000
export HISTSIZE=100000

# Prompt config
setopt PROMPT_SUBST
precmd() { print -rP '%(?.%F{green}√.%F{red}?) %F{white}%2~%F{cyan}$(__git_ps1 " (%s)") ' }
PROMPT='%F{yello}-> '
. $HOME/.zsh/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true

export EDITOR=vim
stty erase '^?'

# export TERM="xterm-256color"
#
#python debugging with pudb instead of pdb
export PYTHONBREAKPOINT=pudb.set_trace

# PATH modification
PATH=/opt/local/bin:$PATH
export PATH="$HOME/.cargo/bin:$PATH"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
export PATH="/usr/local/share/dotnet:$PATH"
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.ebcli-virtual-env/executables:$PATH"

# asdf-vm
. $HOME/.asdf/asdf.sh
# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
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
