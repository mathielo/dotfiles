# Shell aliases and small functions. Sourced by $ZDOTDIR/.zshrc.
#
# These come *after* zimfw modules load, so overrides win.
# Stock zimfw already provides: grep, df, du, ll (basic), plus history/setopt/bindkey defaults.

# Shortcodes for common programs
alias g='git'
alias d='docker'
alias dc='docker compose'
alias k='kubectl'
alias c='claude'

# Modern Rust replacements (override zimfw/utility defaults)
alias ls='eza --color=auto --icons=auto'
alias ll='eza -lh --icons=auto --git'
alias la='eza -lha --icons=auto --git'
alias cat='bat --paging=never'

# Misc
alias reload='source $ZDOTDIR/.zshrc'
mkdcd() { mkdir -p "$1" && cd "$1"; }

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
alias ga.='git add .'
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
