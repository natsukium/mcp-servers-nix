#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update
set -euo pipefail

# The repo contains multiple packages (Azure.Mcp.Server, Template.Mcp.Server, etc.)
# Filter to stable Azure.Mcp.Server releases only (exclude beta/alpha/rc)
nix-update --flake azure-mcp-server --version-regex 'Azure\.Mcp\.Server-([0-9.]+)$' --use-github-releases

"$(nix build .#azure-mcp-server.fetch-deps --no-link --print-out-paths)" pkgs/official/azure/deps.json

echo "Update completed!"
