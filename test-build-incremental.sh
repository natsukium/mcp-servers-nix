#!/usr/bin/env bash
cd /home/tim/src/mcp-servers-nix
nix build .\#mcp-server-filesystem-safurrier
build_result=$?
echo "Build result: $build_result"

if [ $build_result -eq 0 ]; then
    echo "Build successful! Testing executable..."
    echo "Package structure:"
    find result/ -type f -name "mcp-filesystem*" | head -5
    
    echo "Testing import without fastmcp:"
    result/bin/python -c "
try:
    import typer
    print('✅ typer available')
except ImportError as e:
    print('❌ typer not available:', e)

try:
    import typing_extensions
    print('✅ typing_extensions available')
except ImportError as e:
    print('❌ typing_extensions not available:', e)

try:
    import fastmcp
    print('✅ fastmcp available')
except ImportError as e:
    print('❌ fastmcp not available:', e)
"
else
    echo "Build failed with code: $build_result"
fi
