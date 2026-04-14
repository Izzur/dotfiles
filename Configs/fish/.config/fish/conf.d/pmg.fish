# pmg - package manager guard (safedep)
# Routes package-manager commands through pmg for malware scanning + sandbox.
# `bun` is dispatched (it's also a runtime); everything else is fully wrapped.

function bun --wraps bun --description "Route bun install/add/update/x through pmg; passthrough everything else"
    # Global operations bypass pmg — pmg is a project-level guard
    if contains -- --global $argv; or contains -- -g $argv
        command bun $argv
        return
    end
    switch $argv[1]
        case install i add a update up x
            command pmg bun $argv
        case '*'
            command bun $argv
    end
end

function npm --wraps npm --description "Route npm through pmg"
    command pmg npm $argv
end

function npx --wraps npx --description "Route npx through pmg"
    command pmg npx $argv
end

function pnpm --wraps pnpm --description "Route pnpm through pmg"
    command pmg pnpm $argv
end

function pnpx --wraps pnpx --description "Route pnpx through pmg"
    command pmg pnpx $argv
end

function yarn --wraps yarn --description "Route yarn through pmg"
    command pmg yarn $argv
end

function pip --wraps pip --description "Route pip through pmg"
    command pmg pip $argv
end

function pip3 --wraps pip3 --description "Route pip3 through pmg"
    command pmg pip3 $argv
end

function uv --wraps uv --description "Route uv install verbs through pmg; passthrough run/python/etc"
    switch $argv[1]
        case add sync lock remove pip tool
            command pmg uv $argv
        case '*'
            command uv $argv
    end
end

function poetry --wraps poetry --description "Route poetry through pmg"
    command pmg poetry $argv
end
