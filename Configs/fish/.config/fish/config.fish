if status is-interactive
    # Commands to run in interactive sessions can go here

    # Other env loaded by /etc/profile.d/
    fish_add_path ~/.bun/bin
    fish_add_path ~/.local/bin
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

    abbr --add cat bat
    abbr --add cd z
    abbr --add df duf
    abbr --add du dust
    abbr --add ga git add
    abbr --add gb git branch
    abbr --add gco git checkout
    abbr --add gd git diff
    abbr --add gfa git fetch --all --tags --prune --jobs=10
    abbr --add gl git pull
    abbr --add glodsa git log --graph --pretty=\"%Cred%h%Creset -%C\(auto\)%d%Creset %s %Cgreen\(%ad\) %C\(bold blue\)\<%an\>%Creset\" --date=short --all
    abbr --add glola git log --graph --pretty=\"%Cred%h%Creset -%C\(auto\)%d%Creset %s %Cgreen\(%ar\) %C\(bold blue\)\<%an\>%Creset\" --all
    abbr --add gm git merge
    abbr --add gp git push
    abbr --add grs git restore
    abbr --add gsh git show
    abbr --add gst git status
    abbr --add k kubecolor
    abbr --add kctx kubectx
    abbr --add kns kubens
    abbr --add ls lsd
    abbr --add ll lsd -l
    abbr --add lla lsd -l -a
    abbr --add top btm

    # Initialize rbenv for ruby
    eval "$(rbenv init -)"

    # Add alias and enable completions for "k", "kubecolor", "kubectl"
    function kubecolor --wraps kubectl
      command kubecolor $argv
    end

    atuin init fish | source
    zoxide init fish | source

    # Load oh-my-post as last step
    # oh-my-posh init fish --config ~/.config/fish/ohmyposh.toml | source
    # oh-my-posh init fish --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/refs/heads/main/themes/takuya.omp.json' | source
    oh-my-posh init fish --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/refs/heads/main/themes/amro.omp.json' | source
end


# The next line updates PATH for the Google Cloud SDK.
if [ -f '$HOME/.config/google-cloud-sdk/path.fish.inc' ]; . '$HOME/.config/google-cloud-sdk/path.fish.inc'; end

