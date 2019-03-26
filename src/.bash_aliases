
#############
# COREUTILS #
############

# cd
####

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../../'
alias ~='cd ~'

# clear
######

alias c='clear'

# cp
####

# prompt before overwrite
alias cp='cp -iv'

# ls
####

# with MB blocksize
alias llm='ls -alGF --block-size=m'

# hide group in long listing
alias ll='ls -alGF'

alias la='ls -A'
alias l='ls -CF'

# mkdir
#######

# create necessary parent directories
# when needed
alias mkdir='mkdir -pv'

# mv
####

# prompt before overwrite
alias mv='mv -iv'


# Custom
########

# Makes a dir and steps inside
mkd () { mkdir -p "$1" && cd "$1"; }

# Full recursive directory listing
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

# Find file under current directory
ff () { /usr/bin/find . -name "$@" ; }

# Find file whose name starts with given string
ffs () { /usr/bin/find . -name "$@"'*' ; }

# Find file whose name ends with given string
ffe () { /usr/bin/find . -name '*'"$@" ; }

# List of all open sockets
alias lsock='sudo /usr/bin/lsof -i -P'

# List of open TCP sockets
alias lsock_t='sudo /usr/bin/lsof -nP | grep UDP'

# List of open UDP sockets
alias lsock_u='sudo /usr/bin/lsof -nP | grep TCP'

# List of open ports
alias openPorts='sudo /usr/bin/lsof -i | grep LISTEN'

# Defailed list of all open ports
alias allPorts='sudo netstat -tulanp | grep LISTEN'

# Display all firewall rules
alias firewall='sudo /sbin/iptables -L -n -v --line-numbers'

# Update and upgrade at the same time
alias updateapt='sudo apt-get update && sudo apt-get upgrade'

# Zips a folder
zipf () { zip -r "$1".zip "$1" ; }

ii() {
    echo -e "\nYou are logged on ${RED}$HOST"
    echo -e "\nAdditionnal information:$NC " ; uname -a
    echo -e "\n${RED}Users logged on:$NC " ; w -h
    echo -e "\n${RED}Current date :$NC " ; date
    echo -e "\n${RED}Machine stats :$NC " ; uptime
    echo -e "\n${RED}Current network location :$NC " ; scselect
    echo -e "\n${RED}Public facing IP Address :$NC " ;myip
    #echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
    echo
}


#######
# GIT #
#######

if [ -f ~/git/.git_aliases ]; then
    . ~/git/.git_aliases
fi


####################
# SYSTEM RESOURCES #
####################

alias memhogs='ps auxf | sort -nr -k 4 | head -10'
alias cpuhogs='ps auxf | sort -nr -k 3 | head -10'

########
# TMUX #
########

# Attach session
alias tat='tmux att -t'

# List sessions
alias tls='tmux ls'

# List all sessions including tmuxp
alias tll='$HOME/dotbin/tlist.py'

# Kill session
alias tkill='tmux kill-session -t'

# Rename Session
alias trename='tmux rename-session -t'

# Load tmuxp session
alias tstart='tmuxp load'

# Reload tmux source file
alias treload='tmux source-file ~/.tmux.conf'

##########
# PYTHON #
##########

# virtualenvwrapper
alias pywork='source /usr/local/bin/virtualenvwrapper.sh'

alias python3='python3.6'
alias pip3='pip3.6'
alias pip='python2.7 -m pip'


# Pip status using pip-review
# (https://github.com/jgonggrijp/pip-review)
# NOTE: would like to get rid of this dependency at some point
alias preview='pip-review'

# Update all pip packages automatically
alias pupdate='pip-review --auto'

# Update pip packages (step through one-by-one)
alias pupdate_i='pip-review --interactive'


############
# COLORING #
############

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
   alias ls='ls --color=auto'
   alias dir='dir --color=auto'
   alias vdir='vdir --color=auto'

   alias grep='grep --color=auto'
   alias fgrep='fgrep --color=auto'
   alias egrep='egrep --color=auto'
fi

# Use GRC for additionnal colorization
GRC=$(which grc)
if [ -n GRC ]; then
    alias colourify='$GRC -es --colour=auto'
    alias as='colourify as'
    #cvs
    alias configure='colourify ./configure'
    alias diff='colourify diff'
    alias dig='colourify dig'
    alias g++='colourify g++'
    alias gas='colourify gas'
    alias gcc='colourify gcc'
    alias head='colourify head'
    alias ifconfig='colourify ifconfig'
    #irclog
    alias ld='colourify ld'
    #ldap
    #log
    alias make='colourify make'
    alias mount='colourify mount'
    #mtr
    alias netstat='colourify netstat'
    alias ping='colourify ping'
    #proftpd
    alias ps='colourify ps'
    alias tail='colourify tail'
    alias traceroute='colourify traceroute'
    #wdiff
fi


########
# MISC #
########

# If Currently using manual ngrok install in /etc/ngrok (need to localize as a patch)
alias ngrok='/etc/ngrok/ngrok'
