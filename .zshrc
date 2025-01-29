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
