# Personal aliases, sourced from ~/.bashrc after Omarchy's defaults
# ($OMARCHY_PATH/default/bash/aliases and fns/*), so anything defined here wins.

# Shortcodes for common programs
alias dc='docker compose'
alias k='kubectl'

# Misc
mkdcd() { mkdir -p "$1" && cd "$1"; }

# Git shortcuts are git aliases in git/config, run as `g <alias>`. Give `g` git's tab
# completion (branches, files, aliases). bash-completion only loads git's completion on
# the first `git <TAB>`, so source it up front.
if ! declare -F __git_complete >/dev/null && [[ -r /usr/share/bash-completion/completions/git ]]; then
  source /usr/share/bash-completion/completions/git
fi
declare -F __git_complete >/dev/null && __git_complete g __git_main
