# Interactive only
[[ $- != *i* ]] && return

# Editor
export EDITOR=vim
export VISUAL=vim

# zimfw bootstrap
ZIM_HOME="$HOME/.zim"
if [[ ! -e "$ZIM_HOME/zimfw.zsh" ]]; then
  curl -fsSL --create-dirs -o "$ZIM_HOME/zimfw.zsh" \
    https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi
if [[ ! "$ZIM_HOME/init.zsh" -nt "$HOME/.zimrc" ]]; then
  source "$ZIM_HOME/zimfw.zsh" init -q
fi
source "$ZIM_HOME/init.zsh"

# Starship prompt
command -v starship >/dev/null && eval "$(starship init zsh)"

# zoxide (smarter cd)
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# fzf keybindings (Ctrl-R history, Ctrl-T files, Alt-C dirs)
if command -v fzf >/dev/null; then
  source <(fzf --zsh) 2>/dev/null || true
fi

# Aliases (shared)
[[ -f "$HOME/.aliases.zsh" ]] && source "$HOME/.aliases.zsh"

# Per-machine overrides
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
