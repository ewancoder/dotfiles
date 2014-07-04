# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="gnzh"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#export IP_RPI=192.168.100.11
export IP_RPI=82.209.250.6

alias s='sudo '

alias sc="screen -rd"
alias sci="ssh -t root@$IP_RPI screen -rd irssi"
alias scu="screen -rd userver"

alias gis="git status"
alias gia="git add -A"
alias gic="git commit"
alias gicm="git commit -m"
alias gica="git commit --amend"
alias gip="git push --all"
alias gil="git log --oneline --graph --color --all --decorate"
alias gid="git diff"
alias gim="git merge --no-ff"

alias ch="git checkout"

alias y="yaourt"
alias ya="yaourt -S"
alias yau="yaourt -Syua --noconfirm"

alias mnt="sudo mount -o iocharset=utf8"
alias umount="sudo umount"

alias sshrpi="ssh -t root@$IP_RPI"

alias rmnotes="ssh root@$IP_RPI rm /root/.irssi/notifications"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment following line if you want to  shown in the command execution time stamp 
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# # Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

CDPATH=".:~:~/Dropbox"

export TERM=rxvt-256color

export EDITOR=gvim

export PATH=/home/ewancoder/bin:$PATH
