# Docker
alias d='docker'
alias dprune='docker container prune'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dcom='docker-compose'
alias dclog='docker-compose logs -f'

# Kubernetes
alias k='kubectl'
alias kust='kustomize'

# NPM
alias nom="rm -rf node_modules && npm cache clear && npm i"
## React dev
alias knode='killall node'

# VIM
# if test -d /Users; then
#   alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
# fi
# alias vi='vim'
# alias vi='nvim'
alias vi='lvim'
alias vim='lvim'

# Git
alias gtree='git log --graph --oneline --all --decorate'
alias gst='git status'
alias gaa='git add --all'
alias ga='git add'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gpush='git push'
alias gpull='git pull'
alias gco='git checkout'
alias gb='git checkout -b'
alias lg='lazygit'
alias gca='git commit --amend'
alias gcaa='git caa'

# Ruby/Rails
alias rl="rails"
alias rc="rails c"
alias rs="rails s -b 0.0.0.0"
alias bi="bundle install"
alias rr="rails"
alias rrr="rails runner"

# Python
alias activate=". ./env/bin/activate"
alias newenv="python -m venv env && activate && pip install black pylint mypy ipython pudb"
alias pipr="pip install -r"

#Other
alias daisy=ncdu
alias t=task

alias edit="code-insiders"
alias g="z"
alias notes="vi ~/notes"
alias klast="kill -9 %1"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

if test $(command -v bat); then
  alias cat="bat"
fi

if test $(command -v rg); then
  alias grep="rg"
fi

if test $(command -v htop); then
  alias top="htop"
fi

if test $(command -v xdg-open); then
  alias open="xdg-open"
fi

alias wgup="sudo wg-quick up wg0"
