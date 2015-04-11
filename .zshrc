#Oh-My-ZSH Configuration
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="ewancoder" #Better than gnzh
HIST_STAMPS="mm/dd/yyyy"
source $ZSH/oh-my-zsh.sh
bindkey '\e[2~' overwrite-mode #Insert key

#My aliases
source .zsh_aliases
#My environment variables
export TERM=rxvt-256color
export EDITOR=gvim
#List files upon start
ls
cat ~/.agenda 2>/dev/null
cat ~/Dropbox/.agenda 2>/dev/null
