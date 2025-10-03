# Save history
bindkey -e
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory

# Autocompletion for commands like git something
autoload -U compinit; compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':vcs_info:git*' check-for-changes true
zstyle ':vcs_info:git*' formats " %F{blue}(%b)%f %u%c %m"
zstyle ':vcs_info:git*' actionformats "%F{blue}(%b%f %F{red}| %a%f%F{blue})%f"
zstyle ':vcs_info:git*' stagedstr "%F{green}-%f"
zstyle ':vcs_info:git*' unstagedstr "%F{red}x%f"
zstyle ':vcs_info:git*+set-message:*' hooks untracked stashed aheadbehind

+vi-untracked() {
    if [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == 'true'  ]] && \
        [[ -n $(git ls-files --others --exclude-standard) ]] ; then
        hook_com[staged]+='%F{magenta}★%f'
    fi
}
+vi-stashed() {
    if git rev-parse --verify refs/stash &>/dev/null ; then
        hook_com[staged]+=' %F{magenta}(stash)%f'
    fi
}
+vi-aheadbehind() {
    local ahead behind
    local -a gitstatus

    # Exit early in case the worktree is on a detached HEAD
    git rev-parse ${hook_com[branch]}@{upstream} >/dev/null 2>&1 || return 0

    local -a ahead_and_behind=(
        $(git rev-list --left-right --count HEAD...${hook_com[branch]}@{upstream} 2>/dev/null)
    )

    ahead=${ahead_and_behind[1]}
    behind=${ahead_and_behind[2]}

    (( $ahead )) && gitstatus+=( "+${ahead}" )
    (( $behind )) && gitstatus+=( "-${behind}" )

    hook_com[misc]+="%F{magenta}${(j:/:)gitstatus}%f"
}

# Load a module that gets info from GIT
autoload -Uz vcs_info

# Command correction if you made a typo
setopt correct

# Set prompt
precmd() {
    vcs_info
    PS1="%F{yellow}%~%f${vcs_info_msg_0_}
%F{blue}>%f "
}

# Turn on color output for useful commands
alias ls='ls --color=auto'
alias grep='grep --color=auto'

export EDITOR=vi

dotfiles() {
    /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME "$@"
}

dis() {
    dotfiles "$@"
}

userchmod() {
    if [ -z "$1" ]; then
        echo "Folder not specified"
        return
    fi
    sudo chmod -R 644 "$1" && sudo chmod -R u+rwX,go+rX,go-w "$1"
}

strictchmod() {
    if [ -z "$1" ]; then
        echo "Folder not specified"
        return
    fi
    sudo chmod -R 600 "$1" && sudo chmod -R u+rwX,go+X,go-rw "$1"
}

alias gis='git status'
alias gil='git stash list; git log --graph --all --pretty=format:"%C(yellow)%h%Creset %Cgreen(%cr)%Creset %Cblue%an%Creset %C(red)%G?%Creset %C(cyan)%GK%Creset -%C(auto)%d%Creset %s" --decorate'
alias gia='git add -A'
alias giap='git add --patch'
alias gic='git commit -v'
alias gic!='git commit -v --amend'
alias gid='git diff --color=always'
alias gidc='git diff --cached --color=always'
alias gim='git merge --no-ff --log -e'
alias gip='git push'
alias gip!='git push --force-with-lease'
alias gco='git checkout'

alias dotfiles='dotfiles'
alias dis='dotfiles status'
alias dil='dotfiles stash list; dotfiles log --graph --all --pretty=format:"%C(yellow)%h%Creset %Cgreen(%cr)%Creset %Cblue%an%Creset %C(red)%G?%Creset %C(cyan)%GK%Creset -%C(auto)%d%Creset %s" --decorate'
alias dia='dotfiles add -A'
alias diap='dotfiles add --patch'
alias dic='dotfiles commit -v'
alias dic!='dotfiles commit -v --amend'
alias did='dotfiles diff --color=always'
alias didc='dotfiles diff --cached --color=always'
alias dim='dotfiles merge --no-ff --log -e'
alias dip='dotfiles push'
alias dip!='dotfiles push --force-with-lease'
alias dco='dotfiles checkout'

source ~/.wifi-networks-aliases

alias lyrics="sptlrx --player mpris --current 'bold,#FF5555'"

eval $(thefuck --alias)

# Load Angular CLI autocompletion.
source <(ng completion script)

alias workapps='~/.local/bin/work-apps.sh'

alias ctop='docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock quay.io/vektorlab/ctop:latest'

alias sudo='run0'
