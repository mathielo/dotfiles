###
### Zsh Config
###
### https://wiki.archlinux.org/index.php/Zsh
### https://www.smashingmagazine.com/2015/07/become-command-line-power-user-oh-my-zsh-z/
###
zstyle ':completion:*' completer _expand _complete _ignored _correct

autoload -Uz compinit
compinit

HISTFILE=~/.zsh-history
HISTSIZE=10000
SAVEHIST=3000
setopt appendhistory autocd extendedglob
unsetopt beep
bindkey -e

###
### Prezto Config
###
### https://github.com/sorin-ionescu/prezto
### https://wikimatze.de/better-zsh-with-prezto/
### http://mikebuss.com/2014/02/02/a-beautiful-productive-terminal-experience/
###

zstyle ':prezto:load' pmodule \
  'directory' \
  'utility' \
  'completion' \
  'git' \
  'prompt' \
  'syntax-highlighting' \
  'history-substring-search'

zstyle ':prezto:module:prompt' theme 'mathielo'

# Source Prezto
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Some overrides after Prezto has been loaded
unsetopt CORRECT # Disables annoying correction suggestions >:(
unalias rm gs # Disables annoying aliases

###
### 🌈
###

# Mustang theme is only loaded if the terminal emulator Vim runs in supports at least 256 colors (or if you use the GUI version of Vim).
# Hint: If you’re using a terminal emulator that can show 256 colors, try setting TERM=xterm-256color in your terminal configuration or in your shell’s .rc file.
# from <http://nvie.com/posts/how-i-boosted-my-vim/#enable-syntax-highlighting>
TERM=xterm-256color

# LS COLORS
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

###
### Custom aliases
###

# Directories
alias ..='cd ..'
alias du='du -h'
alias df='df -h'

# Git
alias gst='git status'
alias gpom='git pull origin master'
alias gd='git diff'
alias gds='git diff --staged'
alias gck='git checkout'
alias gi='git add -i'
alias ga='git add'
alias ga.='ga .'
alias gf='git fetch -p'
alias gum='gck master && gpom && gf' # Super lazy command: Git Update Master (GUM) - Checkout into master, update from origin, fetch -p

# Docker
alias dc='docker-compose'

###
### Session startup
###

cd

