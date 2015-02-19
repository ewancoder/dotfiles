#Oh-My-ZSH Configuration
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="fino" #Better than gnzh
HIST_STAMPS="mm/dd/yyyy"
source $ZSH/oh-my-zsh.sh
bindkey '\e[2~' overwrite-mode

#My aliases
source .zsh_aliases
#My environment variables
export TERM=rxvt-256color
export EDITOR=gvim
#List files upon start
ls
