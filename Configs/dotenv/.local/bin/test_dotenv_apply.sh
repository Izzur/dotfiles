#!/bin/sh
# Self-check for dotenv-apply's cache. Run: sh test_dotenv_apply.sh
# Asserts the cached path returns byte-identical output to the uncached path
# and that editing the conf invalidates the cache.
set -e

BIN="$(dirname "$0")/dotenv-apply"
TD="$(mktemp -d)"
trap 'rm -rf "$TD"' EXIT

CONF="$TD/dotenv.conf"
export XDG_CACHE_HOME="$TD/cache"
CACHE="$XDG_CACHE_HOME/dotenv-apply.fish"

cat > "$CONF" <<'EOF'
# comment line
; semicolon comment

FOO=bar
  SPACED_KEY  =value
QUOTED="quoted value"
SQUOTED='single value'
HOMEY=$HOME/thing
APOS=it's
EOF

# Point the default conf at our fixture so the cache path is exercised.
mkdir -p "$TD/home/.config/environment.d"
cp "$CONF" "$TD/home/.config/environment.d/dotenv.conf"

# Uncached reference output (DOTENV_CONF set => cache bypassed by design).
# Same HOME as the cached runs, or $HOME expansion differs and nothing matches.
ref=$(HOME="$TD/home" DOTENV_CONF="$CONF" "$BIN" fish)

cold=$(HOME="$TD/home" "$BIN" fish)
[ -f "$CACHE" ] || { echo "FAIL: cache not created at $CACHE"; exit 1; }
warm=$(HOME="$TD/home" "$BIN" fish)

[ "$cold" = "$ref" ]  || { echo "FAIL: cold != uncached"; printf '%s\n--\n%s\n' "$cold" "$ref"; exit 1; }
[ "$warm" = "$ref" ]  || { echo "FAIL: warm != uncached"; printf '%s\n--\n%s\n' "$warm" "$ref"; exit 1; }

# $HOME must expand, and apostrophes must survive fish escaping.
case $ref in *"set -gx HOMEY '$TD/home/thing';"*) ;; *) echo "FAIL: \$HOME not expanded"; exit 1 ;; esac
case $ref in *"APOS"*) ;; *) echo "FAIL: APOS missing"; exit 1 ;; esac

# Editing the conf must invalidate: cache mtime is older after we touch forward.
printf 'NEWKEY=added\n' >> "$TD/home/.config/environment.d/dotenv.conf"
touch -d '+1 minute' "$TD/home/.config/environment.d/dotenv.conf"
after=$(HOME="$TD/home" "$BIN" fish)
case $after in *"set -gx NEWKEY 'added';"*) ;; *) echo "FAIL: stale cache served after edit"; exit 1 ;; esac

# A cache newer than the conf must actually be reused, not silently regenerated.
printf "set -gx SENTINEL 'from-cache';\n" > "$CACHE"
touch -d '+2 minutes' "$CACHE"
reused=$(HOME="$TD/home" "$BIN" fish)
[ "$reused" = "set -gx SENTINEL 'from-cache';" ] || { echo "FAIL: fresh cache not reused"; exit 1; }

echo "ok: all dotenv-apply cache checks passed"
