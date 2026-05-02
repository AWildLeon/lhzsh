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