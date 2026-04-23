# $ZDOTDIR/.zshrc — interactive shell config. Main file for this stack.

# Interactive only
[[ $- != *i* ]] && return

# Keep runtime data out of $HOME root (XDG-ish)
export ZIM_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zim"
export HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"
mkdir -p "${HISTFILE:h}" "${ZSH_COMPDUMP:h}"

# zimfw bootstrap
if [[ ! -e "$ZIM_HOME/zimfw.zsh" ]]; then
  curl -fsSL --create-dirs -o "$ZIM_HOME/zimfw.zsh" \
    https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi
if [[ ! "$ZIM_HOME/init.zsh" -nt "$ZDOTDIR/.zimrc" ]]; then
  source "$ZIM_HOME/zimfw.zsh" init -q
fi
source "$ZIM_HOME/init.zsh"

# Starship prompt
command -v starship >/dev/null && eval "$(starship init zsh)"

# fzf keybindings (Ctrl-R history, Ctrl-T files, Alt-C dirs)
if command -v fzf >/dev/null; then
  source <(fzf --zsh) 2>/dev/null || true
fi

# Aliases
source "$ZDOTDIR/aliases.zsh"

# Per-machine overrides — plain ~/.zshrc is not auto-loaded by zsh when
# ZDOTDIR is set, so we repurpose it as the local config file.
[[ -f "$HOME/.zshrc" ]] && source "$HOME/.zshrc"
