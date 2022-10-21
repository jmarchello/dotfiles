setopt PROMPT_SUBST

# Plugins

## git prompt
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
. $HOME/.zsh/vendor/git-prompt.sh

## kube PS1
KUBE_PS1_PREFIX="["
KUBE_PS1_SUFFIX="]"
KUBE_PS1_SEPARATOR=" "
KUBE_PS1_SYMBOL_ENABLE=false
. $HOME/.zsh/vendor/kube-ps1/kube-ps1.sh

# first line of prompt
precmd() { print -rP '%(?.%F{green}√.%F{red}?) %F{white}%2~%F{cyan} $(kube_ps1)$(__git_ps1 " (%s)") ' }

# Second line (the actual prompt)
PROMPT='%F{yello}# '
