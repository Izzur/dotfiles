# Shell tool initialisation. Needs PATH and env vars from 00-dotenv.fish,
# hence the numeric prefix ordering it after that snippet.
status is-interactive; or exit 0

# rbenv prepends its shims dir; do it before the prompt tools read PATH.
eval "$(rbenv init -)"

tirith init --shell fish | source
atuin init fish | source
zoxide init fish | source
starship init fish | source
intelli-shell init fish | source
