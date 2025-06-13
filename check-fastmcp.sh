#!/bin/bash
# Check if fastmcp is actually available in nixpkgs
( set -x; {
    nix-env -qaP | grep -i fastmcp;
    nix search nixpkgs fastmcp;
    nix eval nixpkgs#python311Packages.fastmcp.version --json 2>/dev/null || echo "fastmcp not found in nixpkgs";
} 2>&1 ) | clip.exe
