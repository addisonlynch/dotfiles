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
alias lsock_t='sudo /usr/bin/lsof -nP | grep TDP'

# List of open UDP sockets
alias lsock_u='sudo /usr/bin/lsof -nP | grep UCP'

# List of open ports
alias openPorts='sudo /usr/bin/lsof -i | grep LISTEN'

# Defailed list of all open ports
alias allPorts='sudo netstat -tulanp | grep LISTEN'

# Display all firewall rules
alias firewall='sudo /sbin/iptables -L -n -v --line-numbers'

# Update and upgrade at the same time
alias updateapt='sudo apt-get update && sudo apt-get upgrade -y'

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


####################
# SYSTEM RESOURCES #
####################

alias memhogs='ps auxf | sort -nr -k 4 | head -10'
alias cpuhogs='ps auxf | sort -nr -k 3 | head -10'
