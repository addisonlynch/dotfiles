alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Tmux shortcut aliases
alias tat='tmux att -t'
alias tls='tmux ls'
alias tkill='tmux kill-session -t'
alias trename='tmux rename-session -t'

alias c='clear'

alias work='source /usr/local/bin/virtualenvwrapper.sh'


#  Currently using manual ngrok install in /etc/ngrok
alias ngrok='/etc/ngrok/ngrok'

alias python3='python3.6'
alias pip3='pip3.6'
alias pip='python2.7 -m pip'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
   alias ls='ls --color=auto'
   alias dir='dir --color=auto'
   alias vdir='vdir --color=auto'

   alias grep='grep --color=auto'
   alias fgrep='fgrep --color=auto'
   alias egrep='egrep --color=auto'
fi

# Ensure



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


# Handy aliases for going up in a directory
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."


