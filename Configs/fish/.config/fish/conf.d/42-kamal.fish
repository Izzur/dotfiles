function kamal --description 'Kamal via podman (rootless)'
    podman run --rm -it \
        -v "$HOME/.ssh:/root/.ssh:ro" \
        -v (pwd):/workdir \
        -w /workdir \
        ghcr.io/basecamp/kamal $argv
end
