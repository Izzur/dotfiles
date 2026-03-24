#!/bin/sh
# Posthook for the `dotenv` group. Runs on `tuckr set dotenv`.
#
# The symlinks alone are not enough: dotenv-export.service must be enabled so
# the expanded environment reaches the systemd user manager (and therefore GUI
# apps) before the graphical session starts. Idempotent -- safe to re-run.
set -e

systemctl --user daemon-reload
systemctl --user enable --now dotenv-export.service

# Prime the shell caches so the first interactive shell after install is fast.
"$HOME/.local/bin/dotenv-apply" fish >/dev/null 2>&1 || true
"$HOME/.local/bin/dotenv-apply" bash >/dev/null 2>&1 || true

echo "dotenv: service enabled. Log out and back in for GUI apps to pick it up."
