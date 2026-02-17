if status is-interactive
    # Commands to run in interactive sessions can go here

    # Other env loaded by /etc/profile.d/
    fish_add_path ~/.bun/bin
    fish_add_path ~/.local/bin
    fish_add_path ~/.cache/.bun/bin
    # set -gx MANGOHUD 1

    set -gx EDITOR nvim
    set -gx PATH $PATH $HOME/.krew/bin
    set -gx MANPAGER "sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
    set -gx STARSHIP_CONFIG "$XDG_CONFIG_HOME/starship/starship.toml"

    # Android SDK
    set -gx ANDROID_SDK_ROOT ~/.config/android-sdk
    fish_add_path $ANDROID_SDK_ROOT/cmdline-tools/latest/bin
    fish_add_path $ANDROID_SDK_ROOT/emulator
    fish_add_path $ANDROID_SDK_ROOT/platform-tools
    # fish_vi_key_bindings

    # Initialize rbenv for ruby
    eval "$(rbenv init -)"

    atuin init fish | source
    zoxide init fish | source
    starship init fish | source
    intelli-shell init fish | source
end


# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/.config/google-cloud-sdk/path.fish.inc" ]; . "$HOME/.config/google-cloud-sdk/path.fish.inc"; end

