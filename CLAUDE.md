# CLAUDE.md

Personal customisation of [Omarchy](https://omarchy.org) (Arch + Hyprland), shared by every
machine that runs it. This repo is where any Omarchy customisation goes: a change made
only in `~/.config` or `~` is lost on the next install or machine.

## How customisations land

- **Layer on Omarchy, never over it.** Its defaults stay in place, and this repo adds next
  to them: a `source` line after Omarchy's in `~/.bashrc`, an `[include]` at the end of
  `~/.config/git/config`, or a symlink for a file Omarchy leaves to the user (e.g.
  `~/.config/hypr/bindings.lua`). Never edit `/usr/share/omarchy/` — reading it is how to
  learn what a default does.
- **Everything goes through `install.sh`.** A new customisation is a file in this repo
  plus an idempotent step in `install.sh`: check first, change only if needed, print
  `ok`/`linked`/`added`. `link()` keeps anything it replaces as `<file>.bak.<epoch>`
  (Omarchy's backup naming). No sudo, except through Omarchy's own installers.
- **Layout follows the tool**: `bash/`, `git/`, `ssh/`, `hypr/`. Anything for one machine
  goes in `hosts/<hostname>/`; `install.sh` applies it only on that host.
- **Don't shadow Omarchy names.** An alias also hides a function with the same name. Check
  `$OMARCHY_PATH/default/bash/` (`aliases`, `fns/`) before adding a shell name. Git
  shortcuts are git aliases in `git/config`, run as `g <alias>` like Omarchy's own `co`,
  `br`, `ci`, `st`; git ignores an alias that shadows one of its commands.
- **Prefer an Omarchy command over hand-editing** where one exists, e.g.
  `omarchy-install-terminal ghostty` for the default terminal. `omarchy commands` lists
  them.
- **Homelab-only setup belongs in `mathielo/homelab`** (network, NFS mounts, cluster
  access). Its SSH hosts go in `~/.ssh/config.d/`, which `ssh/config` includes.

## Omarchy specifics

- **Hyprland config is Lua.** User files in `~/.config/hypr/` load after Omarchy's
  defaults. To change a default keybinding, `hl.unbind(...)` before `o.bind(...)`. Check
  current ones with `omarchy menu keybindings --print`. After any change, run
  `hyprctl reload` and then `hyprctl configerrors`, which must print nothing.
  `hyprctl binds -j` shows Lua bindings as `__lua`, so verify by description instead.
- **Keybinding commands run from `$HOME`** through `sh -c`, with Hyprland's session
  `PATH`.
- **`omarchy-refresh-config <path>` resets a file with `cp -f`**, which writes through a
  symlink into this repo. That shows up as a diff, and `git checkout` restores it.
- **Global git config is `~/.config/git/config`**, not `~/.gitconfig`.
  `git config --global --get` doesn't follow includes, so check effective values with
  `git config --show-origin --get <key>`.
- **Kernel parameters** go in a drop-in under `/etc/limine-entry-tool.d/`, followed by
  `sudo limine-mkinitcpio`.

## Testing `install.sh`

Run it against a scratch home, never the real one. Set **both** `HOME` and
`XDG_CONFIG_HOME`, because the session exports `XDG_CONFIG_HOME=~/.config` and git would
otherwise write to the real config:

```bash
S=$(mktemp -d); mkdir -p "$S/.config/git" "$S/.config/hypr"
cp ~/.bashrc "$S/"; cp "$OMARCHY_PATH/config/git/config" "$S/.config/git/"
HOME=$S XDG_CONFIG_HOME=$S/.config ~/src/dotfiles/install.sh   # twice: the second run must be all "ok"
```

`op` has no account under a scratch home, so the GitHub key step reports `FAILED` there.
That's expected.

## Working style

- **No git operations** unless asked. The user reviews and commits everything. If they've
  already staged files, leave your changes unstaged so `git diff` shows exactly what you
  did. Commits made on request get a short imperative title matching `git log`, no body,
  and no `Co-Authored-By` or session trailers.
- **Public repo:** no secrets. 1Password `op://` paths and public keys are fine.
- **Docs and comments describe the present.** Comment only a non-obvious why, as a
  present-tense reason. No history, no "previously", no session narrative.
- **Keep it tidy.** `README.md` covers installing the repo and nothing else, and
  `install.sh` explains itself through its own comments. Host READMEs cover what's
  specific to that machine.
- **Keep the user's edits.** When they rework something, continue from their version.
