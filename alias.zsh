if command -v eza &> /dev/null; then
    alias ls="eza --color=auto"
    alias ll="eza -l"
    alias la="eza -la"
else
    alias ls="ls --color=auto"
    alias ll="ls -l"
    alias la="ls -la"
fi

alias "cd.."="cd .."
alias "cd..."="cd ../.."
alias "cd...."="cd ../../.."

# Git Aliases
alias g="git"
alias gst="git status"
alias ga="git add"
alias gaa="git add --all"
alias gcmsg="git commit -m"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gl="git pull"
alias gp="git push"
alias gd="git diff"
alias glg="git log --stat"
alias glog="git log --oneline --decorate --graph"

# Docker / Docker Compose Aliases
[[ -x "${commands[docker-compose]:A}" ]] && dccmd='docker-compose' || dccmd='docker compose'

alias dco="$dccmd"
alias dcb="$dccmd build"
alias dce="$dccmd exec"
alias dcps="$dccmd ps"
alias dcrestart="$dccmd restart"
alias dcrm="$dccmd rm"
alias dcr="$dccmd run"
alias dcstop="$dccmd stop"
alias dcup="$dccmd up"
alias dcupb="$dccmd up --build"
alias dcupd="$dccmd up -d"
alias dcupdb="$dccmd up -d --build"
alias dcdn="$dccmd down"
alias dcl="$dccmd logs"
alias dclf="$dccmd logs -f"
alias dclF="$dccmd logs -f --tail 0"
alias dcpull="$dccmd pull"
alias dcstart="$dccmd start"
alias dck="$dccmd kill"
alias dbl='docker build'
alias dcin='docker container inspect'
alias dcls='docker container ls'
alias dclsa='docker container ls -a'
alias dcprune='docker container prune'
alias dib='docker image build'
alias dii='docker image inspect'
alias dils='docker image ls'
alias dipu='docker image push'
alias dipru='docker image prune -a'
alias dirm='docker image rm'
alias dit='docker image tag'
alias dlo='docker container logs'
alias dnc='docker network create'
alias dncn='docker network connect'
alias dndcn='docker network disconnect'
alias dni='docker network inspect'
alias dnls='docker network ls'
alias dnprune='docker network prune'
alias dnrm='docker network rm'
alias dpo='docker container port'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dpu='docker pull'
alias dr='docker container run'
alias drit='docker container run -it'
alias drm='docker container rm'
alias 'drm!'='docker container rm -f'
alias dsprune='docker system prune'
alias dst='docker container start'
alias drs='docker container restart'
alias dsta='docker stop $(docker ps -q)'
alias dstp='docker container stop'
alias dsts='docker stats'
alias dtop='docker top'
alias dvi='docker volume inspect'
alias dvls='docker volume ls'
alias dvprune='docker volume prune'
alias dxc='docker container exec'
alias dxcit='docker container exec -it'

unset dccmd

# Clipboard Integration
if command -v wl-copy &> /dev/null; then
    alias cb="wl-copy"
elif command -v xclip &> /dev/null; then
    alias cb="xclip -selection clipboard"
elif command -v xsel &> /dev/null; then
    alias cb="xsel --clipboard --input"
fi