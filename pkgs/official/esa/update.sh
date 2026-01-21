#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update gnused
set -euo pipefail

SOURCE="$PWD/pkgs/official/esa/default.nix"

echo "Updating version and source hash with nix-update..."
nix-update --flake esa-mcp-server

echo "Calculating new npmDepsHash..."
# Set npmDepsHash to empty to force recalculation
sed -i 's|npmDepsHash = "sha256-[^"]*"|npmDepsHash = ""|' "$SOURCE"

BUILD_OUTPUT=$(nix-build -A esa-mcp-server "$PWD" 2>&1 || true)
NEW_NPM_DEPS_HASH=$(echo "$BUILD_OUTPUT" | grep -oP 'got:\s+sha256-\K[A-Za-z0-9+/=]+' | head -1)

if [[ -z "$NEW_NPM_DEPS_HASH" ]]; then
    echo "Failed to determine new npmDepsHash. Manual intervention may be required." >&2
    echo "Build output:" >&2
    echo "$BUILD_OUTPUT" >&2
    exit 1
fi

sed -i "s|npmDepsHash = \"\"|npmDepsHash = \"sha256-$NEW_NPM_DEPS_HASH\"|" "$SOURCE"

echo "Update completed!"
