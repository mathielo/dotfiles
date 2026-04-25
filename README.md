# dotfiles

Personal shell, prompt, and editor config for Fedora and macOS.

**Stack:** Zsh · [Starship](https://starship.rs) (Gruvbox Rainbow preset) · [zimfw](https://zimfw.sh) plugin manager · modern Rust CLI tools.

## Install

```sh
git clone git@github.com:mathielo/dotfiles.git ~/.dotfiles && ~/.dotfiles/install.sh
```

Supported: **Fedora** and **macOS**. The script `sudo`s for package installs and may prompt for your password again at `chsh`.

After the script finishes: log out and back in (or open a new terminal) and set your terminal font to **MesloLGS NF**. First zsh launch auto-installs zimfw plugins (a few seconds).

## 1Password + SSH keys

The install command above **does not** automatically sets up SSH keys via 1Password. If cloning the `homelab` repository, its [ssh config](https://github.com/mathielo/homelab/blob/main/.config/ssh.config#L6-L13) already contains the necessary settings.

Otherwise, write the GitHub 1P SSH key from 1Password into `~/.ssh/github_1p_ssh.pub`. Then add these to the top of `~/.ssh/config`:

```
# Use the 1Password agent to authenticate with all hosts
Host *
  IdentityAgent ~/.1password/agent.sock

# Specify which key to use for GitHub authentication
Host github.com
  IdentityFile ~/.ssh/github_1p_ssh.pub
  IdentitiesOnly yes
```

### What `install.sh` does

1. **Installs packages** via the native package manager:
   - Fedora: `sudo dnf install -y tilix vim zsh starship fzf eza bat ripgrep fd-find`
   - macOS: `brew install zsh starship fzf eza bat ripgrep fd` + `brew install --cask font-meslo-lg-nerd-font`
2. **Installs MesloLGS Nerd Font** (Fedora only) to `~/.local/share/fonts` from [romkatv/powerlevel10k-media](https://github.com/romkatv/powerlevel10k-media), then runs `fc-cache -f`. On macOS this is handled by the Homebrew cask above.
3. **Installs configs** (prompts before overwriting):

   | Target                    | Source                                  | Method                    |
   | ------------------------- | --------------------------------------- | ------------------------- |
   | `~/.zshenv`               | `~/.dotfiles/zshenv`                    | symlink                   |
   | `~/.zshrc`                | `~/.dotfiles/zdotdir/zshrc.template`    | copy (per-machine tweaks) |
   | `~/.config/starship.toml` | `starship preset gruvbox-rainbow`       | generated                 |

   Only `~/.zshenv` lands in `$HOME`. It sets `ZDOTDIR="$HOME/.dotfiles/zdotdir"`, so zsh loads `.zshrc`, `.zimrc`, and `aliases.zsh` from inside the repo. It also sets `VIMINIT` to source `~/.dotfiles/vimrc` directly — no `~/.vimrc` symlink needed. Runtime data (zim plugins, zsh history, compdump) goes under `$XDG_DATA_HOME` / `$XDG_STATE_HOME` / `$XDG_CACHE_HOME`, keeping `$HOME` clean.

4. **Configures git** globally: `core.editor=vim`, `commit.gpgsign=true`, `delta` as the pager (`core.pager`, `interactive.diffFilter`, `delta.navigate`, `merge.conflictstyle=zdiff3`).
5. **Changes the default shell to zsh** via `chsh -s "$(command -v zsh)"`.

zimfw itself is bootstrapped automatically on first zsh launch by `$ZDOTDIR/.zshrc`, which downloads `zimfw.zsh` and runs `init` to pull all plugins listed in `$ZDOTDIR/.zimrc`.

### Per-machine tweaks

Since `ZDOTDIR` is set, zsh ignores the plain `~/.zshrc` — we repurpose it as the per-machine overrides file. It's copied from `zdotdir/zshrc.template` (not symlinked) so each machine can diverge, and sourced at the end of `$ZDOTDIR/.zshrc`. Use it for machine-specific `PATH`, env vars, or aliases.

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
