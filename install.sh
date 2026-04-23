#!/usr/bin/env bash
set -euo pipefail

DOTFILES="${HOME}/.dotfiles"

# --- Detect OS ---
case "$(uname -s)" in
  Darwin) OS="macos" ;;
  Linux)
    if [[ -f /etc/fedora-release ]]; then
      OS="fedora"
    else
      echo "Only Fedora (Linux) and macOS are supported. See README for manual install."
      exit 1
    fi
    ;;
  *)
    echo "Unsupported OS. Only Fedora and macOS are supported."
    exit 1
    ;;
esac
echo ">> Detected OS: $OS"

# --- Install packages ---
if [[ "$OS" == "macos" ]]; then
  command -v brew >/dev/null || { echo "Install Homebrew first: https://brew.sh"; exit 1; }
  brew install zsh starship fzf eza bat ripgrep fd
  brew install --cask font-meslo-lg-nerd-font
else
  sudo dnf copr enable atim/starship
  sudo dnf install -y zsh starship fzf eza bat ripgrep fd-find

  # MesloLGS Nerd Font (Fedora doesn't ship this specific one)
  FONT_DIR="$HOME/.local/share/fonts"
  if ! fc-list 2>/dev/null | grep -qi "MesloLGS NF"; then
    echo ">> Installing MesloLGS Nerd Font to $FONT_DIR"
    mkdir -p "$FONT_DIR"
    base="https://github.com/romkatv/powerlevel10k-media/raw/master"
    curl -fsSL -o "$FONT_DIR/MesloLGS NF Regular.ttf"     "$base/MesloLGS%20NF%20Regular.ttf"
    curl -fsSL -o "$FONT_DIR/MesloLGS NF Bold.ttf"        "$base/MesloLGS%20NF%20Bold.ttf"
    curl -fsSL -o "$FONT_DIR/MesloLGS NF Italic.ttf"      "$base/MesloLGS%20NF%20Italic.ttf"
    curl -fsSL -o "$FONT_DIR/MesloLGS NF Bold Italic.ttf" "$base/MesloLGS%20NF%20Bold%20Italic.ttf"
    fc-cache -f "$FONT_DIR" >/dev/null
  fi
fi

# --- Symlink configs ---
# Only ~/.zshenv lives in $HOME — it sets ZDOTDIR so zsh reads everything
# else from $DOTFILES/zdotdir/. vimrc is loaded via $VIMINIT (set in zshenv).
ln -isn "$DOTFILES/zshenv" "$HOME/.zshenv"

# Per-machine local overrides: plain ~/.zshrc is unused by zsh once ZDOTDIR
# is set, so we repurpose it as the local file. Copied (not symlinked) so
# each machine can diverge.
cp -i "$DOTFILES/zdotdir/zshrc.template" "$HOME/.zshrc"

# Starship Gruvbox Rainbow preset — generated, not symlinked (upstream-tracked)
starship preset gruvbox-rainbow -o "$HOME/.config/starship.toml"

# --- Git config ---
git config --global core.editor "vim"
git config --global commit.gpgsign true

# --- Switch default shell to zsh ---
ZSH_PATH="$(command -v zsh)"
if [[ "${SHELL:-}" != "$ZSH_PATH" ]]; then
  echo ">> Changing default shell to zsh — may prompt for password"
  chsh -s "$ZSH_PATH"
fi

cat <<'EOF'

Done.

Next:
- Open a new terminal (log out/in if chsh was applied).
- First zsh launch auto-installs zimfw plugins (a few seconds).
- Set your terminal font to "MesloLGS NF" for the prompt glyphs.
- Per-machine tweaks go in ~/.zshrc (ignored by the dotfiles repo).
EOF
