#!/usr/bin/env bash
set -euo pipefail

DOTFILES="${HOME}/.dotfiles"

backup_and_link() {
  local src="$1" dst="$2"
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    mv "$dst" "${dst}.bak.$(date +%s)"
  fi
  mkdir -p "$(dirname "$dst")"
  ln -sfn "$src" "$dst"
}

backup_and_link "$DOTFILES/bashrc"         "$HOME/.bashrc"
backup_and_link "$DOTFILES/bash_profile"   "$HOME/.bash_profile"
backup_and_link "$DOTFILES/inputrc"        "$HOME/.inputrc"
backup_and_link "$DOTFILES/vimrc"          "$HOME/.vimrc"
backup_and_link "$DOTFILES/starship.toml"  "$HOME/.config/starship.toml"

mkdir -p "$HOME/.vim/sessions"

git config --global core.editor "vim"

command -v starship >/dev/null || cat <<'EOF'

starship is not installed. Install it, then re-open your terminal:
    Fedora:  sudo dnf install starship
    macOS:   brew install starship
    Other:   https://starship.rs/#quick-install
EOF

echo "Dotfiles installed. Open a fresh terminal."
