#!/usr/bin/env python3
"""Check if Python packages are available in current environment"""

packages_to_check = [
    "fastmcp",
    "typer", 
    "typing-extensions"
]

for package in packages_to_check:
    try:
        __import__(package)
        print(f"✅ {package} - available")
    except ImportError:
        print(f"❌ {package} - not available")
