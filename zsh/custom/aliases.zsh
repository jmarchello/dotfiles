alias cdHighwire='cd ~/dev/mersoft/javascript/iris/highwire'
alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs'

# Docker
alias drun='docker run -it --rm'
alias drunapp='docker run -it --rm -v "$PWD":/app -w /app'
alias dexec='docker exec -it'
alias dprune='docker container prune'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dcom='docker-compose'
alias nom="rm -rf node_modules && npm cache clear && npm i"
