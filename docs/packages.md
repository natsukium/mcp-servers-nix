# Packages Guide

## Overview

mcp-servers-nix provides standalone Nix packages for MCP servers. These can be used independently of the module system — useful when you want to run a server directly or manage configuration yourself.

For the module-based configuration approach, see the [Module Usage Guide](module-usage.md).

## Running Without Installing

Run MCP server packages directly without installing them:

```bash
# Using nix-shell
nix-shell -p "(import (builtins.fetchTarball \"https://github.com/natsukium/mcp-servers-nix/archive/main.tar.gz\") {}).mcp-server-fetch" --run mcp-server-fetch

# Using flakes
nix run github:natsukium/mcp-servers-nix#mcp-server-fetch
```

## Installing a Package

```bash
# Without flakes
nix-env -f https://github.com/natsukium/mcp-servers-nix/archive/main.tar.gz -iA mcp-server-fetch

# Using flakes
nix profile install github:natsukium/mcp-servers-nix#mcp-server-fetch
```

## Using Overlays

Add all MCP server packages to your nixpkgs via the provided overlay:

```nix
# In your configuration.nix or home.nix
{
  nixpkgs.overlays = [
    # classic
    (import (builtins.fetchTarball "https://github.com/natsukium/mcp-servers-nix/archive/main.tar.gz")).overlays.default
    # or with flakes
    # mcp-servers-nix.overlays.default
  ];

  # Then install packages through pkgs
  environment.systemPackages = with pkgs; [
    mcp-server-fetch
  ];
}
```

## Available Packages

### Reference Implementations

| Package | Description |
|---------|-------------|
| `mcp-server-everything` | MCP reference test server |
| `mcp-server-fetch` | Web content fetching |
| `mcp-server-filesystem` | Local filesystem access |
| `mcp-server-git` | Git repository operations |
| `mcp-server-memory` | Knowledge graph memory |
| `mcp-server-sequential-thinking` | Sequential thinking |
| `mcp-server-time` | Time and timezone tools |

### Official Servers

| Package | Description |
|---------|-------------|
| `context7-mcp` | Context7 documentation lookup |
| `deepl-mcp-server` | DeepL translation |
| `esa-mcp-server` | esa.io integration |
| `mastra-mcp-docs-server` | Mastra documentation |
| `nd-mcp` | Netdata monitoring |
| `notion-mcp-server` | Notion integration |
| `playwright-mcp` | Playwright browser automation |
| `serena` | Serena code intelligence |
| `slite-mcp-server` | Slite knowledge base |
| `tavily-mcp` | Tavily search |
