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
    PS1="%F{yellow}%n%f%F{blue}@%f%F{red}%m%f%f %F{yellow}%~%f${vcs_info_msg_0_}
%F{blue}>%f "
}

# Export shared parts between shells.
source .shellrc

# Experimentation (only zsh for now)
#eval $(thefuck --alias)

# Load Angular CLI autocompletion.
source <(ng completion script)

export GPG_TTY=$(tty) # We need this for console GPG.
