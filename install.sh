#!/usr/bin/env bash
set -euo pipefail

DOTFILES="${HOME}/.dotfiles"

mkdir -p "$HOME/.config"

ln -isn "$DOTFILES/bashrc"        "$HOME/.bashrc"
ln -isn "$DOTFILES/inputrc"       "$HOME/.inputrc"
ln -isn "$DOTFILES/vimrc"         "$HOME/.vimrc"
ln -isn "$DOTFILES/starship.toml" "$HOME/.config/starship.toml"
cp -i   "$DOTFILES/bash_profile"  "$HOME/.bash_profile"

git config --global core.editor "vim"
git config --global commit.gpgsign true

command -v starship >/dev/null || cat <<'EOF'

starship is not installed. Install it, then re-open your terminal:
    Fedora:  sudo dnf install starship
    macOS:   brew install starship
    Other:   https://starship.rs/#quick-install
EOF

echo "Dotfiles installed. Open a fresh terminal."
