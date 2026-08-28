### Prequisites

- Install [tuckr](https://github.com/RaphGL/Tuckr#installation)

### Installation

> [!CAUTION]
> _**Warning**: Backup your local dotfiles before installing new ones._

For example, to install the `waybar` dotfiles into local system:

```bash
tuckr add waybar
```

To check status of installed dotfiles:

```bash
tuckr status
```

### Git (`git` group)

`.gitconfig` includes `~/.config/delta/themes.gitconfig` and selects the
`arctic-fox` theme from it, so the `delta` group has to be installed alongside
it or delta starts with an unknown theme:

```bash
tuckr add git delta
```

### Environment variables (`dotenv` group)

`Configs/dotenv` holds the single source of truth for user environment variables
and `PATH`: `~/.config/environment.d/dotenv.conf`. Three consumers read that one
file — systemd's native `environment.d` reader, `dotenv-export.service` (pushes
the `$HOME`-expanded values into the systemd user manager so GUI apps see them),
and `dotenv-apply` (emits `export`/`set -gx` for bash and fish). All three read
every `*.conf` in the directory, in lexical order with later files winning.

Values are data, not shell. Both parsers strip one layer of matching surrounding
quotes and substitute `$HOME` / `${HOME}`; nothing else is interpreted. Write a
value exactly as the receiving program should see it and do not shell-escape it
— `environment.d` is a shared drop-in directory, so a value that got `eval`ed
would run whatever any file there contained on every interactive shell.

Because the service has to be enabled, this group needs `set` rather than `add`
so its posthook runs:

```bash
tuckr set dotenv bash fish
```

Then log out and back in, so the graphical session inherits the environment.

#### Hosts without systemd (WSL2)

`dotenv-apply` needs nothing from systemd, so the system works unchanged on a
WSL2 distro whose PID 1 is WSL's own init and where `systemctl` isn't
installed. The posthook detects this and skips enabling the service;
`dotenv-export.service` is then an inert file, and the two shell rc files are
the only consumers. There is no user manager or graphical session to push the
environment into separately, so nothing is lost.

Host-specific values live in a drop-in rather than a forked `dotenv.conf`. Any
`*.conf` in `~/.config/environment.d/` is read in lexical order with later files
winning — the same rule systemd's `environment.d` uses — so `zz-wsl.conf` sorts
after `dotenv.conf` and overrides it:

```bash
tuckr set dotenv bash fish
tuckr add dotenv-wsl          # WSL machine only
```

Read `Configs/dotenv-wsl/.config/environment.d/zz-wsl.conf` before using it. It
needs `appendWindowsPath = false` in `/etc/wsl.conf`, because `dotenv.conf`
exports a full literal `PATH` that would otherwise wipe WSL's injected Windows
entries and break `clip.exe` / `explorer.exe`.

Machine-specific things to review on a new host after installing:

- `PATH` in `dotenv.conf` is a full literal list (no `$PATH` self-reference,
  since the systemd reader cannot expand it). Entries that don't exist on the
  new machine are harmless, but hardware-specific ones like `/opt/rocm/bin` are
  only useful where that hardware is.

Verify after install:

```bash
systemctl --user show-environment | grep HERMES_HOME   # service reached the manager
sh ~/.local/bin/test_dotenv_apply.sh                   # dotenv-apply cache self-check
```
