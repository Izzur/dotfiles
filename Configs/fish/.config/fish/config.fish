if status is-interactive
    # Commands to run in interactive sessions can go here

    # Other env loaded by /etc/profile.d/
    fish_add_path ~/.bun/bin
    fish_add_path ~/.local/bin
    fish_add_path ~/.cache/.bun/bin
    # set -gx MANGOHUD 1
    function fish_greeting
      # fastfetch
    end
    set -gx EDITOR nvim
    set -gx PATH $PATH $HOME/.krew/bin
    set -gx MANPAGER "sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

    # Android SDK
    set -gx ANDROID_SDK_ROOT ~/.config/android-sdk
    fish_add_path $ANDROID_SDK_ROOT/cmdline-tools/latest/bin
    fish_add_path $ANDROID_SDK_ROOT/emulator
    fish_add_path $ANDROID_SDK_ROOT/platform-tools
    # fish_vi_key_bindings

    # Initialize rbenv for ruby
    eval "$(rbenv init -)"

    # Add alias and enable completions for "k", "kubecolor", "kubectl"
    function kubecolor --wraps kubectl
      command kubecolor $argv
    end

    # Enable completions for zoxide
    function z --wraps cd
      command z $argv
    end

    atuin init fish | source
    zoxide init fish | source

    # Load oh-my-post as last step
    oh-my-posh init fish --config '~/.config/oh-my-posh/1_shell.omp.json' | source
end


# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/.config/google-cloud-sdk/path.fish.inc" ]; . "$HOME/.config/google-cloud-sdk/path.fish.inc"; end

