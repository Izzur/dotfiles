# Apply the single source of truth: ~/.config/environment.d/*.conf
#
# Runs FIRST in conf.d so every later snippet builds on the canonical PATH.
# dotenv-apply emits `set -gx PATH '...'` — a wholesale replacement, not an
# append. When this lived in config.fish (which fish loads AFTER all of conf.d)
# it silently erased every PATH entry conf.d had added, e.g. go.fish's $GOBIN.
if status is-interactive
    ~/.local/bin/dotenv-apply fish | source

    ulimit -n 65536
end
