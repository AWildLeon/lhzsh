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
alias dco="docker compose"
alias dcupd="docker compose up -d"
alias dcdn="docker compose down"
alias dcl="docker compose logs"
alias dclf="docker compose logs -f"
alias dps="docker ps"
alias dpa="docker ps -a"
alias di="docker images"
alias dex="docker exec -it"

# Clipboard Integration
if command -v wl-copy &> /dev/null; then
    alias cb="wl-copy"
elif command -v xclip &> /dev/null; then
    alias cb="xclip -selection clipboard"
elif command -v xsel &> /dev/null; then
    alias cb="xsel --clipboard --input"
fi