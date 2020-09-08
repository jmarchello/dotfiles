# Docker
alias drun='docker run -it --rm'
alias drunapp='docker run -it --rm -v "$PWD":/app -w /app'
alias dexec='docker exec -it'
alias dprune='docker container prune'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dcom='docker-compose'
alias dclog='docker-compose logs -f'

# NPM
alias nom="rm -rf node_modules && npm cache clear && npm i"
## React dev
alias knode='killall node'

# VIM
if test -d /Users; then
  alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
fi
alias vi='vim'
# alias vi='nvim'

# Git
alias gtree='git log --graph --oneline --all --decorate'
alias gst='git status'
alias gaa='git add --all'
alias ga='git add'
alias gcm='git commit -m'
alias gcam='git commit -a -m'

# Ruby/Rails
alias rl="rails"
alias rc="rails c"
alias rs="rails s -b 0.0.0.0"
alias bi="bundle install"

# Python
alias activate=". ./env/bin/activate"
alias newenv="python -m venv env && activate && pip install black pylint mypy ipython pudb"
function pipr() {
  if [ -z "$1" ]
  then
    pip install -r "$1"
  else
    pip install -r requirements.txt
  fi
}

#Other
alias daisy=ncdu

alias edit="code-insiders"
alias g="z"
alias notes="vi ~/notes"
alias klast="kill -9 %1"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
