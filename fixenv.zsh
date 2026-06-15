#Fix $HOME in case it's not set, which can cause issues in some environments (like certain CI systems or minimal Docker containers).
if [ -z "$HOME" ]; then
    export HOME=$(realpath ~)
fi

#Fix $HOSTNAME if not set, which can cause issues with some prompts and tools that rely on it.
if [ -z "$HOSTNAME" ]; then
    export HOSTNAME=$(hostname)
fi

# Check if ~/.local/bin is in PATH, and if not, add it
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

#Check if USER is set, if not try to set it from the id command, if that also fails, set it to "unknown"
if [[ -z "$USER" ]]; then
    export USER=$(id -un 2>/dev/null || echo "unknown")
fi

#SSH_AUTH_SOCK: unset if it points to a non-existent file.
if [[ -n "$SSH_AUTH_SOCK" && ! -e "$SSH_AUTH_SOCK" ]]; then
    unset SSH_AUTH_SOCK
fi

# Set SSH_AUTH_SOCK to a existing socket if it is not set
if [[ -z "$SSH_AUTH_SOCK" ]]; then
    #Check $XDG_RUNTIME_DIR/ssh-agent{.socket}
    if [[ -S "$XDG_RUNTIME_DIR/ssh-agent.socket" ]]; then
        export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
    elif [[ -S "$XDG_RUNTIME_DIR/ssh-agent" ]]; then
        export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent"
    fi
fi