# dotfiles

Personal layer on top of [Omarchy](https://omarchy.org): added next to its defaults, never
over them.

## Install

Needs 1Password running and signed in, with **Use the SSH agent** and **Integrate with
1Password CLI** on (Settings → Developer). Clone over HTTPS, since the SSH key only gets
set up by `install.sh`:

```bash
git clone https://github.com/mathielo/dotfiles ~/src/dotfiles
~/src/dotfiles/install.sh
git -C ~/src/dotfiles remote set-url origin git@github.com:mathielo/dotfiles.git
```

Then open a new terminal. `install.sh` is safe to re-run.

Machines with their own setup have a directory under [`hosts/`](hosts/), named after the
hostname.
