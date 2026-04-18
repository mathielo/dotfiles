# dotfiles

Personal shell, Vim, and terminal config. Bash + starship on Fedora/macOS.

# Install

```
git clone git@github.com/mathielo/dotfiles.git ~/.dotfiles && ~/.dotfiles/install.sh
```

The installer symlinks from this repo into `$HOME` (backing up any pre-existing regular file as `<name>.bak.<timestamp>`):

| Symlink | Target |
|---|---|
| `~/.bashrc` | `~/.dotfiles/bashrc` |
| `~/.bash_profile` | `~/.dotfiles/bash_profile` |
| `~/.inputrc` | `~/.dotfiles/inputrc` |
| `~/.vimrc` | `~/.dotfiles/vimrc` |
| `~/.config/starship.toml` | `~/.dotfiles/starship.toml` |

# Install starship

The installer doesn't install starship (sudo needed). Run one of:

- Fedora: `sudo dnf install starship`
- macOS: `brew install starship`
- Other: https://starship.rs/#quick-install

# Terminal profiles

- Linux: [`terminals/Tilix/`](./terminals/Tilix)
- Mac: [`terminals/iTerm2/`](./terminals/iTerm2)
