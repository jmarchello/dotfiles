[[ $(type -t cd) == "alias" ]] && unalias cd

# Make
alias jmake='make -f .josh/makefile'

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
alias vi='nvim'
alias e="$EDITOR"
# alias vi='lvim'
# alias vim='lvim'

# Git
alias g="git"
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
alias grev='git review'

# Sqlite
alias db="sqlite3"

# Fossil
alias ff='fossil'

function rdebug {
  local command="$@"
  eval "RUBY_DEBUG_OPEN=1 $command"
}

# Ruby
alias bi="bundle install"
alias be="bundle exec"

# Rails
alias rc="bin/rails c"
alias rs="bin/rails s -b 0.0.0.0"
alias rr="bin/rails"
alias rrr="bin/rails runner"
alias rdm="bin/rails db:migrate"
alias rup="bin/setup"

# Python
alias activate=". ./venv/bin/activate"
alias newenv="python -m venv venv && activate"
alias pipr="pip install -r"

#Other
alias daisy=ncdu
alias t=task
alias v=vagrant
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
alias zel=zellij
alias eenv="source eenv_script"
alias ai="ollama run llama3.2"

alias edit="code-insiders"
alias notes="vi ~/notes"
alias klast="kill -9 %1"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

if command -v bat >/dev/null 2>&1; then
  alias cat="bat"
fi

if command -v rg >/dev/null 2>&1; then
  alias grep="rg"
fi

if command -v btop >/dev/null 2>&1; then
  alias top="btop"
fi

if command -v eza >/dev/null 2>&1; then
  alias ls="eza --sort=type --icons --git"
fi

if command -v xdg-open >/dev/null 2>&1; then
  alias open="xdg-open"
fi

alias wgup="sudo wg-quick up wg0"
