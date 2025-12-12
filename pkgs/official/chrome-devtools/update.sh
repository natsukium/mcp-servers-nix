#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-prefetch-url jq
set -euo pipefail

PACKAGE_DIR="pkgs/official/chrome-devtools"
SOURCE="$PACKAGE_DIR/default.nix"

# Get latest version from npm registry
LATEST_VERSION=$(curl -s "https://registry.npmjs.org/chrome-devtools-mcp/latest" | jq -r '.version')

echo "Latest version: $LATEST_VERSION"

# Get the current version from the nix file
CURRENT_VERSION=$(grep -oP "version = \"\K[^\"]+\"" "$SOURCE" | head -1 | tr -d '"')
echo "Current version: $CURRENT_VERSION"

if [[ "$LATEST_VERSION" == "$CURRENT_VERSION" ]]; then
    echo "Already at latest version"
    exit 0
fi

# Fetch the tarball and calculate its hash
TARBALL_URL="https://registry.npmjs.org/chrome-devtools-mcp/-/chrome-devtools-mcp-${LATEST_VERSION}.tgz"
NEW_HASH=$(nix-prefetch-url --type sha256 "$TARBALL_URL" 2>&1 | tail -1)

echo "New hash: sha256-$NEW_HASH"

# Update version and hash in the nix file
sed -i "s/version = \".*\";/version = \"$LATEST_VERSION\";/" "$SOURCE"
sed -i "s|hash = \"sha256-[^\"]*\";|hash = \"sha256-$NEW_HASH\";|" "$SOURCE"

echo "Update completed!"
