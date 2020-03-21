# Attach session
alias tat='tmux att -t'

# List sessions
alias tls='tmux ls'

# List all sessions including tmuxp
alias tll='python $HOME/dotbin/tlist.py'
alias tlist='python $HOME/dotbin/tlist.py'

# Kill session
alias tkill='tmux kill-session -t'

# Rename Session
alias trename='tmux rename-session -t'

# Load tmuxp session
alias tstart='tmuxp load'

# Reload tmux source file
alias treload='tmux source-file ~/.tmux.conf'