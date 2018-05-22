# Docker
alias drun='docker run -it --rm'
alias drunapp='docker run -it --rm -v "$PWD":/app -w /app'
alias dexec='docker exec -it'
alias dprune='docker container prune'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dcom='docker-compose'
alias nom="rm -rf node_modules && npm cache clear && npm i"

# NPM
## React dev
alias reactdev='npm start & && npm run dev'
alias knode='killall node'

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
