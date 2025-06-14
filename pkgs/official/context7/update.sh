#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update gnused
set -euo pipefail

SOURCE="$PWD/pkgs/official/context7/default.nix"

echo "Updating version and source hash with nix-update..."
nix-update --flake context7-mcp

echo "Calculating new output hash..."
BUILD_OUTPUT=$(nix-build -A context7-mcp "$PWD" 2>&1 || true)
NEW_OUTPUT_HASH=$(echo "$BUILD_OUTPUT" | grep -oP 'got:\s+sha256-\K[A-Za-z0-9+/=]+' | head -1)

if [[ -z "$NEW_OUTPUT_HASH" ]]; then
    echo "Failed to determine new output hash. Manual intervention may be required." >&2
    echo "Build output:" >&2
    echo "$BUILD_OUTPUT" >&2
    exit 1
fi

sed -i "s|outputHash = \"sha256-[^\"]*\"|outputHash = \"sha256-$NEW_OUTPUT_HASH\"|" "$SOURCE"

echo "Update completed!"
