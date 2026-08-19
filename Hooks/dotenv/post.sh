#!/bin/sh
# Posthook for the `dotenv` group. Runs on `tuckr set dotenv`.
#
# On a systemd host the symlinks alone are not enough: dotenv-export.service
# must be enabled so the expanded environment reaches the systemd user manager
# (and therefore GUI apps) before the graphical session starts.
#
# On a systemd-less host (WSL2, where PID 1 is WSL's own init and systemctl
# isn't installed) there is no user manager to push into, and no session to
# inherit it. dotenv-apply in .bashrc / config.fish is the whole system there,
# so skip this half rather than fail the hook. Idempotent -- safe to re-run.
set -e

if command -v systemctl >/dev/null 2>&1 && [ -d /run/systemd/system ]; then
    systemctl --user daemon-reload
    systemctl --user enable --now dotenv-export.service
    echo "dotenv: service enabled. Log out and back in for GUI apps to pick it up."
else
    echo "dotenv: no systemd, skipping dotenv-export.service (shells read the confs directly)."
fi

# Prime the shell caches so the first interactive shell after install is fast.
"$HOME/.local/bin/dotenv-apply" fish >/dev/null 2>&1 || true
"$HOME/.local/bin/dotenv-apply" bash >/dev/null 2>&1 || true
