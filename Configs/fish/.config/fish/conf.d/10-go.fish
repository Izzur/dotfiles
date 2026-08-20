# Go XDG directory layout
set -gx GOPATH "$XDG_DATA_HOME/go"
if set -q XDG_BIN_HOME
    set -gx GOBIN "$XDG_BIN_HOME"
else
    set -gx GOBIN "$GOPATH/bin"
end

# Add GOBIN to PATH (no duplicates)
fish_add_path --path "$GOBIN"
