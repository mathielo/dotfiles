# Interactive only
case $- in
  *i*) ;;
    *) return;;
esac

# History
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend
shopt -s cmdhist

# Shell behavior
shopt -s autocd
shopt -s globstar
shopt -s extglob
shopt -s checkwinsize

# Bash completion (Fedora/Debian path)
if [[ -r /usr/share/bash-completion/bash_completion ]]; then
  . /usr/share/bash-completion/bash_completion
fi

# Shortcodes for common programs
alias g='git'
alias d='docker'
alias dc='docker compose'
alias k='kubectl'
alias c='claude'

# Linux general commands
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -lha'
alias grep='grep --color=auto'
alias reload='source ~/.bash_profile'
function mkdcd() {
    mkdir $1 && cd $1
}

# Git
alias gst='git status'
alias gpom='git pull origin main'
alias gc='git commit'
alias gcm='git commit -m'
alias gd='git diff'
alias gds='git diff --staged'
alias gbs='git switch'
alias gi='git add -i'
alias gs='git show'
alias ga='git add'
alias gp='git push'
alias gf='git fetch -p'
alias gum='gbs main && gpom && gf'
alias gus='gbs staging && git pull origin staging && gf'
alias gl='git log'
alias glss='git log --show-signature'
# Deletes all local branches except main (lists first, pauses 3s)
alias gpurge='git branch && sleep 3 && git branch | grep -Ev "(main)" | xargs git branch -D'
# Interactive clean of untracked files, preserving .env*
alias gclean='git clean -Xfdi -e \!".env*"'

# Starship prompt
if command -v starship >/dev/null; then
  eval "$(starship init bash)"
fi
