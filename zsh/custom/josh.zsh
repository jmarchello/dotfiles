# source ~/.git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true

export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

# start the ssh-agent
# eval `ssh-agent -s`

# set -o vi

# MYPROMPT -> '|\A| $(__git_ps1 "(%s) [\W]") >> '
# COLORS -> '\[\e[0;33m\] PROMPT \[\e[m\]'
# PS1="\[\e[0;33m\] |\A| $(__git_ps1 "(%s)") [\W] >> \[\e[m\]"

# export PATH="$HOME/.jenv/bin:$PATH"
# eval "$(jenv init -)"
# export JAVA_HOME=$(/usr/libexec/java_home)
# export ANDROID_HOME=/usr/local/Cellar/android-sdk/24.4.1_1/
export EDITOR=vim
stty erase '^?'

export GREP_OPTIONS='--exclude-dir=build --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=log'

# export TERM="xterm-256color"


# npm completion
if [ -f ~/.npm-completion.bash ]; then
  . ~/.npm-completion.bash
fi

#python debugging with pudb instead of pdb
export PYTHONBREAKPOINT=pudb.set_trace

# aws cli completion
# complete -C aws_completer aws

PATH=/opt/local/bin:$PATH
# eval "$(rbenv init -)"
export PATH="$HOME/.cargo/bin:$PATH"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
export PATH="/usr/local/share/dotnet:$PATH"
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin
export PATH="$HOME/bin:$PATH"
# eval "$(pyenv init -)"
export PATH="/Users/josh.marchello/.ebcli-virtual-env/executables:$PATH"
# eval "$(pyenv virtualenv-init -)"
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash
