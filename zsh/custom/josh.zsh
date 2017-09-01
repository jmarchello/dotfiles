# source ~/.git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true

# set -o vi

# MYPROMPT -> '|\A| $(__git_ps1 "(%s) [\W]") >> '
# COLORS -> '\[\e[0;33m\] PROMPT \[\e[m\]'
# PS1="\[\e[0;33m\] |\A| $(__git_ps1 "(%s)") [\W] >> \[\e[m\]"

# export PATH="$HOME/.jenv/bin:$PATH"
# eval "$(jenv init -)"
export JAVA_HOME=$(/usr/libexec/java_home)
export ANDROID_HOME=/usr/local/Cellar/android-sdk/24.4.1_1/
# export EDITOR=subl
stty erase '^?'

# Postgres.app binaries
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/9.4/bin

# workspace aliases
alias workIcor="cd ~/development/rails/mersoft/icor"
alias workTest="cd ~/development/rails/mersoft/mtestp-web"
alias startMailcatcher='rvm use 2.2.2@mailcatcher && mailcatcher -f'

export TERM="xterm-256color"

PATH=/opt/local/bin:$PATH

###############################
# Tool aliases
###############################

# VIM
alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
alias vi='/Applications/MacVim.app/Contents/MacOS/Vim'

# Git
# alias gtree='git log --graph --oneline --all --decorate'
# alias gst='git status'
# alias gaa='git add --all'
# alias ga='git add'
# alias gcm='git commit -m'
# alias gcam='git commit -a -m'

# Ruby/Rails
alias rc="rails c"
alias rs="rails s -b 0.0.0.0"
alias bi="bundle install"

# npm completion
if [ -f ~/.npm-completion.bash ]; then
  . ~/.npm-completion.bash
fi

# aws cli completion
# complete -C aws_completer aws

# Load RVM into a shell session *as a function*
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
