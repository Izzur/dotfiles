# Single source of truth: ~/.config/environment.d/dotenv.conf
# Apply all env vars + PATH from that one file. Do NOT duplicate values here.
if status is-interactive
    ~/.local/bin/dotenv-apply fish | source

    ulimit -n 65536

    # Initialize rbenv for ruby
    eval "$(rbenv init -)"

    tirith init --shell fish | source
    atuin init fish | source
    zoxide init fish | source
    starship init fish | source
    intelli-shell init fish | source
end

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/.config/google-cloud-sdk/path.fish.inc" ]
    . "$HOME/.config/google-cloud-sdk/path.fish.inc"
end

# remove aliases by running `pmg setup remove` or deleting the line 
[ -f "$HOME/.pmg.rc" ] && source "$HOME/.pmg.rc"  # PMG source aliases

# remove PMG shims by running `pmg setup remove` or deleting the line
fish_add_path --prepend "$HOME/.pmg/bin"  # PMG shims
