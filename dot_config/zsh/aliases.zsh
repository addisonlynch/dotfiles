# ── Navigation ──────────────────────────────────────────
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# ── ls ──────────────────────────────────────────────────
alias ll="ls -alGF"
alias la="ls -A"
alias l="ls -CF"

# ── Shortcuts ───────────────────────────────────────────
alias c="clear"
alias g="git"
alias lg="lazygit"
alias y="yazi"

# ── Grep ────────────────────────────────────────────────
alias grep="grep --color=auto"

# ── Networking ──────────────────────────────────────────
alias lsock="sudo lsof -i -P"
alias openports="sudo lsof -i | grep LISTEN"
