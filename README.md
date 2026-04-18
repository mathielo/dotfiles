# dotfiles

Personal shell, Vim, and terminal config. Bash + starship on Fedora/macOS.

# Install

```
git clone git@github.com/mathielo/dotfiles.git ~/.dotfiles && ~/.dotfiles/install.sh
```

The installer prompts before overwriting any existing file. Most files are symlinked; `~/.bash_profile` is copied so it can be customized per machine.

| File                      | Source                      | Method  |
| ------------------------- | --------------------------- | ------- |
| `~/.bash_profile`         | `~/.dotfiles/bash_profile`  | copy    |
| `~/.bashrc`               | `~/.dotfiles/bashrc`        | symlink |
| `~/.inputrc`              | `~/.dotfiles/inputrc`       | symlink |
| `~/.vimrc`                | `~/.dotfiles/vimrc`         | symlink |
| `~/.config/starship.toml` | `~/.dotfiles/starship.toml` | symlink |

# Install starship

The installer doesn't install starship (sudo needed). Run one of:

- Fedora: `sudo dnf install starship`
- macOS: `brew install starship`
- Other: https://starship.rs/#quick-install

# Terminal profiles

- Linux: [`terminals/Tilix/`](./terminals/Tilix)
- Mac: [`terminals/iTerm2/`](./terminals/iTerm2)
