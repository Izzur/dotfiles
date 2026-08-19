#
# ~/.bashrc
#

# Load ble.sh first of everything
# Guarded on the file: this .bashrc is shared with hosts that don't have ble.sh
# installed (WSL), where an unguarded source prints an error on every shell.
[[ $- == *i* && -f ~/.local/share/blesh/ble.sh ]] && source ~/.local/share/blesh/ble.sh --noattach

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ============================ BEGIN USER CONFIG ============================ #

# Single source of truth: ~/.config/environment.d/dotenv.conf
# Apply all env vars + PATH from that one file. Do NOT duplicate values here.
if [ -x "$HOME/.local/bin/dotenv-apply" ]; then
    eval "$("$HOME/.local/bin/dotenv-apply" bash)"
fi

# Fallback PATH in case the shell starts with an empty PATH (rare edge case).
if [ -z "${PATH-}" ]; then export PATH=/usr/local/bin:/usr/bin:/bin; fi

# ble.sh static abbreviation/alias
ble-sabbrev -l cat='bat'
ble-sabbrev -l df='duf'
ble-sabbrev -l du='dust'
ble-sabbrev -l ga='git add'
ble-sabbrev -l gb='git branch'
ble-sabbrev -l gco='git checkout'
ble-sabbrev -l gd='git diff'
ble-sabbrev -l gfa='git fetch --all --tags --prune --jobs=10'
ble-sabbrev -l gl='git pull'
ble-sabbrev -l glodsa='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" --date=short --all'
ble-sabbrev -l glola='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all'
ble-sabbrev -l gm='git merge'
ble-sabbrev -l gp='git push'
ble-sabbrev -l grs='git restore'
ble-sabbrev -l gsh='git show'
ble-sabbrev -l gst='git status'
ble-sabbrev -l k='kubecolor'
ble-sabbrev -l kcx='kubectx'
ble-sabbrev -l kns='kubens'
ble-sabbrev -l ls='lsd'
ble-sabbrev -l ll='lsd -l'
ble-sabbrev -l lla='lsd -l -a'
ble-sabbrev -l top='btm'

shopt -s autocd

# ============================  END USER CONFIG  ============================ #

# Attach after everything
[[ ! ${BLE_VERSION-} ]] || ble-attach

# . "$HOME/.atuin/bin/env"

[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
# eval "$(atuin init bash)"

# remove aliases by running `pmg setup remove` or deleting the line
[ -f "$HOME/.pmg.rc" ] && source "$HOME/.pmg.rc" # PMG source aliases

# dcg: warn if hook was silently removed from Claude Code settings
if command -v dcg &>/dev/null && command -v jq &>/dev/null; then
  if [ -f "$HOME/.claude/settings.json" ] &&
    ! jq -e '.hooks.PreToolUse[]? | select(.hooks[]?.command | test("dcg$"))' \
      "$HOME/.claude/settings.json" &>/dev/null; then
    printf '\033[1;33m[dcg] Hook missing from ~/.claude/settings.json — run: dcg install\033[0m\n'
  fi
fi

# remove PMG shims by running `pmg setup remove` or deleting the line
export PATH="$HOME/.pmg/bin:$PATH"  # PMG shims

# tirith.sh -- guarded, not installed on every host
command -v tirith &>/dev/null && eval "$(tirith init --shell bash)"
