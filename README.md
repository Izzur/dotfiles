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

### Environment variables (`dotenv` group)

`Configs/dotenv` holds the single source of truth for user environment variables
and `PATH`: `~/.config/environment.d/dotenv.conf`. Three consumers read that one
file — systemd's native `environment.d` reader, `dotenv-export.service` (pushes
the `$HOME`-expanded values into the systemd user manager so GUI apps see them),
and `dotenv-apply` (emits `export`/`set -gx` for bash and fish).

Because the service has to be enabled, this group needs `set` rather than `add`
so its posthook runs:

```bash
tuckr set dotenv bash fish
```

Then log out and back in, so the graphical session inherits the environment.

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
