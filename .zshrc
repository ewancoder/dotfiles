# Save history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory

# Autocompletion for commands like git something
autoload -U compinit; compinit

# Command correction if you made a typo
setopt correct

# Custom prompt
PS1=$'%F{green}%m%f %F{yellow}%~%f
%F{blue}>%f '

# Turn on color output for useful commands
alias ls='ls --color=auto'
alias grep='grep --color=auto'

export EDITOR=vi

dotfiles() {
    /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME "$@"
}

alias gis='git status'
alias gil='git stash list; git log --graph --all --pretty=format:"%C(yellow)%h%Creset %Cgreen(%cr)%Creset -%C(auto)%d%Creset %s" --decorate'
alias gia='git add -A'
alias giap='git add --patch'
alias gic='git commit -v'
alias gic!='git commit -v --amend'
alias gid='git diff --color=always'
alias gidc='git diff --cached --color=always'
alias gim='git merge --no-ff --log -e'
alias gip='git push'
alias gco='git checkout'

alias dotfiles='dotfiles'
alias dis='dotfiles status'
alias dil='dotfiles stash list; dotfiles log --graph --all --pretty=format:"%C(yellow)%h%Creset %Cgreen(%cr)%Creset -%C(auto)%d%Creset %s" --decorate'
alias dia='dotfiles add -A'
alias diap='dotfiles add --patch'
alias dic='dotfiles commit -v'
alias dic!='dotfiles commit -v --amend'
alias did='dotfiles diff --color=always'
alias didc='dotfiles diff --cached --color=always'
alias dim='dotfiles merge --no-ff --log -e'
alias dip='dotfiles push'
alias dco='dotfiles checkout'

rdp() {
    xfreerdp3 /v:$1 /u:$2 +compression +clipboard +fonts +aero +window-drag +menu-anims /dynamic-resolution
}

rdpwin() {
    rdp 192.168.1.185 "Ivan Zyranau"
}
