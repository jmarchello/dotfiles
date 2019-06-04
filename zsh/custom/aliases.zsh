# Docker
alias drun='docker run -it --rm'
alias drunapp='docker run -it --rm -v "$PWD":/app -w /app'
alias dexec='docker exec -it'
alias dprune='docker container prune'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dcom='docker-compose'
alias nom="rm -rf node_modules && npm cache clear && npm i"
alias portainer="docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer"
alias scom="docker-compose -f ~/dev/mersoft/splash/mworkp-docker-compose/docker-compose.yml"
alias mssql="docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=mersoft1!' -e 'MSSQL_PID=Express' -p 1433:1433 -h dmerx-db -d mcr.microsoft.com/mssql/server:2017-latest-ubuntu"

# NPM
## React dev
alias reactdev='npm start & && npm run dev'
alias knode='killall node'

# VIM
alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
# alias vi='/Applications/MacVim.app/Contents/MacOS/Vim'
alias vi='nvim'

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

#Other
alias daisy=ncdu
