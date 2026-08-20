# Based on https://gist.github.com/tommyip/cf9099fa6053e30247e5d0318de2fb9e
# Changes:
# * Instead of overriding cd, we detect directory change. This allows the script to work
#   for other means of cd, such as z.
# * Update syntax to work with new versions of fish.
# * Handle virtualenvs that are not located in the root of a git directory.
# * Custom env.fish to source

function __auto_source_venv --on-variable PWD --description "Activate/Deactivate virtualenv on directory change"
    status --is-command-substitution; and return

    # Left the git dir that owned the last env.fish: tear down what it set.
    if set -q __env_fish_gitdir
        set -l new_gitdir
        if git rev-parse --show-toplevel &>/dev/null
            set new_gitdir (realpath (git rev-parse --show-toplevel))
        end
        if test "$new_gitdir" != "$__env_fish_gitdir"
            if test -n "$VIRTUAL_ENV"
                deactivate
            end
            # New vars created by env.fish: unset.
            for n in $__env_fish_new_names
                set -q $n; and set -e $n
            end
            # Overwritten vars: restore the pre-env.fish value.
            for i in (seq 1 (count $__env_fish_over_names))
                set -gx $__env_fish_over_names[$i] (string split -- "\x1f" $__env_fish_over_vals[$i])
            end
            set -e __env_fish_new_names __env_fish_over_names __env_fish_over_vals __env_fish_gitdir
        end
    end

    # Check if we are inside a git directory
    if git rev-parse --show-toplevel &>/dev/null
        set gitdir (realpath (git rev-parse --show-toplevel))
        set cwd (pwd -P)
        # While we are still inside the git directory, find the closest
        # virtualenv starting from the current directory.
        while string match "$gitdir*" "$cwd" &>/dev/null
            if test -e "$XDG_CONFIG_HOME/fish/venv/$gitdir/env.fish"
                # ponytail: tracks exported (env) vars only — `env` for names excludes
                # fish internal read-only/color vars that can't be set anyway. Values are
                # read via $$n to preserve list structure, \x1f-joined, and kept as a single
                # list element via `string collect` so multiline values don't misalign the
                # snapshot. Non-exported globals set by env.fish are not tracked.
                for t in __env_fish_gitdir __env_fish_new_names __env_fish_over_names __env_fish_over_vals
                    set -q $t; and set -e $t
                end
                set -l before_names (env | string match -r '^[A-Za-z_][A-Za-z0-9_]*=' | string replace -r '=$' '')
                set -l before_vals
                for n in $before_names
                    set -l joined (string join -- "\x1f" $$n | string collect)
                    # guarantee exactly one element per name even for empty/0-element vars
                    if test -z "$joined"
                        set -a before_vals ""
                    else
                        set -a before_vals $joined
                    end
                end
                source "$XDG_CONFIG_HOME/fish/venv/$gitdir/env.fish" &>/dev/null
                set -l new_names
                set -l over_names
                set -l over_vals
                for i in (seq 1 (count $before_names))
                    set n $before_names[$i]
                    set new (string join -- "\x1f" $$n | string collect)
                    if test "$new" != "$before_vals[$i]"
                        set -a over_names $n
                        set -a over_vals $before_vals[$i]
                    end
                end
                for n in (env | string match -r '^[A-Za-z_][A-Za-z0-9_]*=' | string replace -r '=$' '')
                    if not contains -- $n $before_names
                        set -a new_names $n
                    end
                end
                set -g __env_fish_new_names $new_names
                set -g __env_fish_over_names $over_names
                set -g __env_fish_over_vals $over_vals
                set -g __env_fish_gitdir $gitdir
                return
            else
                set cwd (path dirname "$cwd")
            end
        end
    end
    # If virtualenv activated but we are not in a git directory, deactivate.
    if test -n "$VIRTUAL_ENV"
        deactivate
    end
end
