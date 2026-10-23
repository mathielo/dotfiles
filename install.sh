#!/usr/bin/env bash
# Layers personal config on top of a stock Omarchy install. Safe to re-run:
# every step checks before it changes anything, and a file that would be
# replaced is kept as <file>.bak.<epoch> (Omarchy's own backup naming).
#
# Needs 1Password running and signed in, with the CLI integration on
# (Settings → Developer), for the GitHub public key.

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOST="$(hostnamectl hostname 2>/dev/null || hostname)"
HOST_DIR="$DOTFILES/hosts/$HOST"

# GitHub's published ed25519 host key fingerprint:
# https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints
GITHUB_ED25519_FP="SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU"

# link <source> <target>: symlink target → source, backing up whatever was there.
link() {
  local src="$1" dst="$2"
  if [[ -L $dst && "$(readlink "$dst")" == "$src" ]]; then
    echo "ok      $dst"
    return
  fi
  mkdir -p "$(dirname "$dst")"
  if [[ -e $dst || -L $dst ]]; then
    mv "$dst" "$dst.bak.$(date +%s)"
    echo "backup  $dst.bak.*"
  fi
  ln -s "$src" "$dst"
  echo "linked  $dst → $src"
}

# Terminal: Ghostty as the default, through Omarchy's installer (may ask for sudo).
if [[ "$(omarchy-default-terminal)" == "ghostty" ]]; then
  echo "ok      default terminal ghostty"
else
  omarchy-install-terminal ghostty
fi

# Shell: one source line at the end of Omarchy's ~/.bashrc, after its defaults.
line="source \"$DOTFILES/bash/aliases.bash\""
if grep -qxF "$line" ~/.bashrc; then
  echo "ok      ~/.bashrc"
else
  printf '\n# Personal aliases (dotfiles)\n%s\n' "$line" >> ~/.bashrc
  echo "added   ~/.bashrc → aliases.bash"
fi

# Hyprland: keybinding overrides, in the file Omarchy leaves for them.
link "$DOTFILES/hypr/bindings.lua" ~/.config/hypr/bindings.lua

# Git: include our config after Omarchy's ~/.config/git/config, so ours wins.
if git config --global --get-all include.path | grep -qxF "$DOTFILES/git/config"; then
  echo "ok      git include"
else
  git config --global --add include.path "$DOTFILES/git/config"
  echo "added   git include → git/config"
fi

# SSH: config, the GitHub key's public half, and GitHub's host key. Without the
# host key the first git-over-SSH fails: there's no ssh-askpass to confirm it.
mkdir -p -m 700 ~/.ssh ~/.ssh/config.d
link "$DOTFILES/ssh/config" ~/.ssh/config
if [[ -s ~/.ssh/gh1p.pub ]]; then
  echo "ok      ~/.ssh/gh1p.pub"
elif pubkey="$(op read "op://Private/GitHub 1P SSH/public key")"; then
  echo "$pubkey" > ~/.ssh/gh1p.pub
  echo "wrote   ~/.ssh/gh1p.pub"
else
  echo "FAILED  ~/.ssh/gh1p.pub — is 1Password running with CLI integration on? Re-run after." >&2
fi
if ssh-keygen -F github.com >/dev/null 2>&1; then
  echo "ok      known_hosts github.com"
else
  key="$(ssh-keyscan -t ed25519 github.com 2>/dev/null)"
  if [[ "$(ssh-keygen -lf - <<<"$key" | awk '{print $2}')" == "$GITHUB_ED25519_FP" ]]; then
    echo "$key" >> ~/.ssh/known_hosts
    echo "added   known_hosts github.com"
  else
    echo "FAILED  github.com host key does not match $GITHUB_ED25519_FP — not added" >&2
  fi
fi

# Host-specific files, if this machine has a hosts/ entry.
if [[ -d $HOST_DIR ]]; then
  [[ -f $HOST_DIR/monitors.lua ]] && link "$HOST_DIR/monitors.lua" ~/.config/hypr/monitors.lua
  if [[ -f $HOST_DIR/memmap-badram.conf ]] && ! grep -q 'memmap=' /proc/cmdline; then
    echo "TODO    this boot has no memmap= — apply it per hosts/$HOST/README.md"
  fi
else
  echo "note    no hosts/$HOST/ — host-specific steps skipped"
fi
