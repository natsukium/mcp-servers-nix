#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=flake:nixpkgs -i bash -p nix-update gnused
set -euo pipefail

echo enter the update script

SOURCE="$PWD/pkgs/official/context7/default.nix"

echo "$SOURCE"

nix-update --flake context7-mcp --print-commit-message

BUILD_OUTPUT=$(nix-build -A context7-mcp "$PWD" 2>&1 || true)
NEW_OUTPUT_HASH=$(echo "$BUILD_OUTPUT" | grep -oP 'got:\s+sha256-\K[A-Za-z0-9+/=]+' | head -1)

if [[ -z "$NEW_OUTPUT_HASH" ]]; then
    echo "Failed to determine new output hash. Manual intervention may be required." >&2
    echo "Build output:" >&2
    echo "$BUILD_OUTPUT" >&2
    exit 1
fi

sed -i "s|outputHash = \"sha256-[^\"]*\"|outputHash = \"sha256-$NEW_OUTPUT_HASH\"|" "$SOURCE"
