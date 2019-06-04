# source ~/.git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true

export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

# start the ssh-agent
eval `ssh-agent -s`

# set -o vi

# MYPROMPT -> '|\A| $(__git_ps1 "(%s) [\W]") >> '
# COLORS -> '\[\e[0;33m\] PROMPT \[\e[m\]'
# PS1="\[\e[0;33m\] |\A| $(__git_ps1 "(%s)") [\W] >> \[\e[m\]"

# export PATH="$HOME/.jenv/bin:$PATH"
# eval "$(jenv init -)"
# export JAVA_HOME=$(/usr/libexec/java_home)
# export ANDROID_HOME=/usr/local/Cellar/android-sdk/24.4.1_1/
export EDITOR=nvim
stty erase '^?'

export GREP_OPTIONS='--exclude-dir=build --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=log'

# Postgres.app binaries
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/9.4/bin

# export TERM="xterm-256color"

PATH=/opt/local/bin:$PATH

# npm completion
if [ -f ~/.npm-completion.bash ]; then
  . ~/.npm-completion.bash
fi

# aws cli completion
# complete -C aws_completer aws

export PATH="$HOME/.cargo/bin:$PATH"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
export PATH="/Users/jmarchello/Library/Python/3.6/bin:$PATH"
export PATH="/usr/local/share/dotnet:$PATH"
# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin
