# ── Git aliases ─────────────────────────────────────────
# Status / info
alias gs="git status"
alias gss="git status -s"
alias gd="git diff"
alias gl="git log --graph --pretty=format:'%C(bold)%h%Creset%C(magenta)%d%Creset %s %C(yellow)<%an> %C(cyan)(%cr)%Creset' --abbrev-commit --date=relative"
alias gcount="git shortlog -sn"

# Staging
alias ga="git add"
alias gap="git add -p"
alias gall="git add -A"
alias gus="git reset HEAD"

# Commits
alias gc="git commit -v"
alias gcm="git commit -v -m"
alias gca="git commit -v -a"
alias gcam="git commit -v -am"

# Branches
alias gb="git branch"
alias gba="git branch -a"
alias gbd="git branch -d"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gcom="git checkout main"

# Remote
alias gf="git fetch --all --prune"
alias gp="git push"
alias gpo="git push origin"
alias gpu="git push --set-upstream"
alias gpr="git pull --rebase"

# Merge / rebase
alias gm="git merge"
alias gcp="git cherry-pick"
alias gsu="git submodule update --init --recursive"

# Stash
alias gstl="git stash list"
alias gstd="git stash drop"

# Tags
alias gt="git tag"
alias gta="git tag -a"
alias gtd="git tag -d"
alias gtl="git tag -l"
