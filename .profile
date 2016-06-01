
#aliases
alias ls='ls -FG'
alias profiler='. ~/.profile'

#git
alias gitlogc='gitclog.sh'
alias gitpullm='gitpullm.sh'
#git config --global alias.ll 'log --oneline --graph --all --decorate'


#paths
export PATH=$PATH:/Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin/
export PATH=$PATH:~/adt-bundle-mac/sdk/platform-tools/
export PATH=$PATH:~/scripts

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto verbose"
export GIT_PS1_SHOWCOLORHINTS=

source ~/scripts/git-prompt.sh
source ~/scripts/git-completion.bash

C_ORANGE='\[\e[2;33m\]'
C_BLACK='\[\e[0m\]'
C_GREEN='\[\e[0;32m\]'
C_BLUE='\[\e[1;36m\]'

PS1_PART_DIR="$C_ORANGE[$C_GREEN\W$C_ORANGE]$C_BLACK"
PS1_PART_GIT=' $(__git_ps1 "[%s] " )'
PS1_PART_USER="$C_BLUE\u$C_ORANGE:$C_BLACK"
export PS1=$PS1_PART_DIR$PS1_PART_GIT$PS1_PART_USER
# export PS1='[\u@\h \W$(declare -F __git_ps1 &>/dev/null && __git_ps1 " (%s)")]\$ '
# export PS1="[\e[0;32m\w\e[m] $(__git_ps1 " [%s]") \[\033[1;36m\]\u\[\033[1;33m\]-> \[\033[0m\]"
