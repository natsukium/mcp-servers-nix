#!/bin/bash
# Check UV project status for both repos
( set -x; {
    echo "=== mcp-filesystem-safurrier UV status ===";
    cd /home/tim/src/mcp-filesystem-safurrier;
    ls -la uv.lock pyproject.toml 2>/dev/null || echo "Missing UV files";
    echo "";
    
    echo "=== mcp-nixos UV status ===";
    # First check if we have mcp-nixos locally
    if [ -d /home/tim/src/mcp-nixos ]; then
        cd /home/tim/src/mcp-nixos;
        ls -la uv.lock pyproject.toml 2>/dev/null || echo "Missing UV files";
    else
        echo "mcp-nixos not cloned locally yet";
    fi;
    echo "";
    
    echo "=== Checking current uv2nix availability ===";
    nix eval --expr "builtins.hasAttr \"uv2nix\" (import <nixpkgs> {})" 2>/dev/null || echo "uv2nix not available in current nixpkgs";
} 2>&1 ) | clip.exe
