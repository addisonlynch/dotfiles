##########
# SYSTEM #
##########

if [ -f ~/.aliases/system.aliases.bash ]; then
    . ~/.aliases/system.aliases.bash
fi

########
# MISC #
########

# If Currently using manual ngrok install in /etc/ngrok (need to localize as a patch)
alias ngrok='/etc/ngrok/ngrok'


#######
# GIT #
#######

if [ -f ~/.aliases/git.aliases.bash ]; then
    . ~/.aliases/git.aliases.bash
fi

########
# TMUX #
########

if [ -f ~/.aliases/tmux.aliases.bash ]; then
    . ~/.aliases/tmux.aliases.bash
fi

##########
# PYTHON #
##########

if [ -f ~/.aliases/python.aliases.bash ]; then
    . ~/.aliases/python.aliases.bash 
fi

##########
# DOCKER #
##########

if [ -f ~/.aliases/docker.aliases.bash ]; then
    . ~/.aliases/docker.aliases.bash 
fi

############
# COLORING #
############

if [ -f ~/.aliases/coloring.aliases.bash ]; then
    . ~/.aliases/coloring.aliases.bash
fi

