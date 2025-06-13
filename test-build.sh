#!/usr/bin/env bash
cd /home/tim/src/mcp-servers-nix
nix build .\#mcp-server-filesystem-safurrier
echo "Build result: $?"
if [ $? -eq 0 ]; then
    echo "Testing with typer dependency..."
    result/bin/mcp-filesystem --help
else
    echo "Build failed - checking what went wrong"
fi
