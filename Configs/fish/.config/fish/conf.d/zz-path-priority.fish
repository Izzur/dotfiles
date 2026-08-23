# Final word on PATH order. MUST sort after every conf.d snippet that prepends,
# which is why the name starts with "zz-" (fish sources conf.d by basename in
# ASCII order, so digits < letters < "zz-").
#
# vite-plus.fish sources vite-plus's env.fish, which deletes its own PATH entry
# and re-prepends it on every single shell. That puts vite-plus/bin ahead of
# .pmg/bin, so npm, npx, pnpm, pnpx and yarn resolve to vite-plus's corepack
# shims and skip pmg's malware scan. dotenv.conf already orders these two
# correctly; this snippet only re-asserts that order after vite-plus moves it.
#
# fish_add_path cannot do this. It only ADDS a missing entry and never moves an
# existing one, and .pmg/bin is always already present by this point:
#
#   set -gx PATH /a /b ~/.pmg/bin /c; fish_add_path -P --prepend ~/.pmg/bin
#   -> /a /b ~/.pmg/bin /c                 (unchanged)
#
# Remove-then-prepend is the only primitive that reorders. The loop removes
# every copy, so a duplicate from the universal $fish_user_paths collapses too.
#
# Undo with `pmg setup remove`, or just delete this file.
if test -d "$HOME/.pmg/bin"
    while set -l i (contains -i -- "$HOME/.pmg/bin" $PATH)
        set -e PATH[$i]
    end
    set -gx PATH "$HOME/.pmg/bin" $PATH
end
