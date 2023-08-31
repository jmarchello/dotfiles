setopt PROMPT_SUBST

# Plugins

## git prompt
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
. $HOME/.zsh/vendor/git-prompt.sh

# first line of prompt
precmd() { print -rP '%(?.%F{green}√.%F{red}?) %F{white}%2~%F{cyan}$(__git_ps1 " (%s)") ' }

# Second line (the actual prompt)
PROMPT='%F{yello}# '
