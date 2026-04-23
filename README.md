# dotfiles

Personal shell, prompt, and editor config for Fedora and macOS.

**Stack:** Zsh · [Starship](https://starship.rs) (Gruvbox Rainbow preset) · [zimfw](https://zimfw.sh) plugin manager · modern Rust CLI tools.

## Install

```sh
git clone git@github.com:mathielo/dotfiles.git ~/.dotfiles
cd ~/.dotfiles && ./install.sh
```

Supported: **Fedora** and **macOS**. The script `sudo`s for package installs and may prompt for your password again at `chsh`.

After the script finishes: log out and back in (or open a new terminal) and set your terminal font to **MesloLGS NF**. First zsh launch auto-installs zimfw plugins (a few seconds).

### What `install.sh` does

1. **Installs packages** via the native package manager:
   - Fedora: `sudo dnf install -y zsh starship fzf eza bat ripgrep fd-find`
   - macOS: `brew install zsh starship fzf eza bat ripgrep fd` + `brew install --cask font-meslo-lg-nerd-font`
2. **Installs MesloLGS Nerd Font** (Fedora only) to `~/.local/share/fonts` from [romkatv/powerlevel10k-media](https://github.com/romkatv/powerlevel10k-media), then runs `fc-cache -f`. On macOS this is handled by the Homebrew cask above.
3. **Symlinks configs** (prompts before overwriting):

   | Target                    | Source                            | Method                    |
   | ------------------------- | --------------------------------- | ------------------------- |
   | `~/.zshrc`                | `~/.dotfiles/zshrc`               | symlink                   |
   | `~/.zimrc`                | `~/.dotfiles/zimrc`               | symlink                   |
   | `~/.aliases.zsh`          | `~/.dotfiles/aliases.zsh`         | symlink                   |
   | `~/.vimrc`                | `~/.dotfiles/vimrc`               | symlink                   |
   | `~/.zshrc.local`          | `~/.dotfiles/zshrc.local`         | copy (per-machine tweaks) |
   | `~/.config/starship.toml` | `starship preset gruvbox-rainbow` | generated                 |

4. **Configures git** globally: `core.editor=vim`, `commit.gpgsign=true`, `delta` as the pager (`core.pager`, `interactive.diffFilter`, `delta.navigate`, `merge.conflictstyle=zdiff3`).
5. **Changes the default shell to zsh** via `chsh -s "$(command -v zsh)"`.

zimfw itself is bootstrapped automatically on first zsh launch by `zshrc`, which downloads `zimfw.zsh` and runs `init` to pull all plugins listed in `zimrc`.

### Per-machine tweaks

`~/.zshrc.local` is copied (not symlinked) so each machine can diverge. It's sourced at the end of `~/.zshrc` — use it for machine-specific PATH entries, aliases, or env vars. The repo's copy is just a commented template.

## Installed tools

### CLI utilities

| Name                                             | What it does                                            | Quick example                                            |
| ------------------------------------------------ | ------------------------------------------------------- | -------------------------------------------------------- |
| [starship](https://github.com/starship/starship) | Cross-shell prompt (Gruvbox Rainbow preset)             | See [here](https://starship.rs/presets/#gruvbox-rainbow) |
| [fzf](https://github.com/junegunn/fzf)           | Fuzzy finder — Ctrl-R history, Ctrl-T files, Alt-C dirs | `vim $(fzf)`                                             |
| [eza](https://github.com/eza-community/eza)      | Modern `ls` with colors/icons/git status                | `ll`, `eza --tree`                                       |
| [bat](https://github.com/sharkdp/bat)            | `cat` with syntax highlighting + git gutter             | `bat README.md`                                          |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Fast recursive `grep`                                   | `rg TODO`                                                |
| [fd](https://github.com/sharkdp/fd)              | Friendlier `find`                                       | `fd '\.md$'`                                             |
| [delta](https://github.com/dandavison/delta)     | Side-by-side syntax-highlighted git diffs               | `git diff` (auto)                                        |

### Zsh plugins (managed by zimfw)

| Name                                                                                      | What it does                               | Quick example                |
| ----------------------------------------------------------------------------------------- | ------------------------------------------ | ---------------------------- |
| [zimfw](https://github.com/zimfw/zimfw)                                                   | Zsh plugin manager                         | `zimfw upgrade`              |
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)                   | Greys-out the next command from history    | Type `gi`, press → to accept |
| [fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting) | Colors commands as you type                | Typos render red             |
| [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search) | Prefix-based up-arrow search               | Type `git`, press ↑          |
| [fzf-tab](https://github.com/Aloxaf/fzf-tab)                                              | Replaces Tab completion with an fzf picker | `cd <Tab>`                   |

## Keeping things up to date

- Plugins: `zimfw upgrade`
- Starship: `brew upgrade starship` / `sudo dnf upgrade starship`
- Dotfiles: `cd ~/.dotfiles && git pull`

## Terminal profiles

- Linux: [`terminals/Tilix/`](./terminals/Tilix)
- macOS: [`terminals/iTerm2/`](./terminals/iTerm2)
