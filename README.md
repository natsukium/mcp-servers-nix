# mcp-servers-nix-plus

> **This is mcp-servers-nix-plus**, a community fork of
> [mcp-servers-nix](https://github.com/natsukium/mcp-servers-nix) that is not
> merged upstream yet. It accepts pull requests for new MCP servers and
> periodically merges updates from upstream. This fork exists because the
> upstream maintainer has a slow review cycle and some packages take months to
> get merged.

A Nix-based configuration framework for Model Control Protocol (MCP) servers
with ready-to-use packages.

## Overview

This repository provides both MCP server packages and a Nix framework for
configuring and deploying MCP servers. It offers a modular approach to
configuring various MCP servers with a consistent interface.

## Features

- **Modular Configuration**: Define and combine multiple MCP server
  configurations
- **Reproducible Builds**: Leverage Nix for reproducible and declarative server
  setups
- **Pre-configured Modules**: Ready-to-use configurations for popular MCP server
  types
- **Security-focused**: Better handling credentials and sensitive information
  through `envFile` and `passwordCommand`, with pinned server versions
- **Framework Support**: Integrates with
  [Flakes](docs/module-usage.md#using-flakes),
  [flake-parts](docs/module-usage.md#using-flake-parts),
  [devenv](docs/module-usage.md#using-devenv), and
  [Home Manager](docs/module-usage.md#using-home-manager)

## Quick Start

Run an MCP server directly:

```bash
# Upstream packages
nix run github:natsukium/mcp-servers-nix#mcp-server-fetch

# Plus packages (fork-only)
nix run github:antono/mcp-servers-nix-plus#google-calendar-mcp
```

Generate a configuration file with `mkConfig`:

```nix
# config.nix
let
  pkgs = import <nixpkgs> { };
  mcp-servers-nix = import (fetchTarball
    "https://github.com/antono/mcp-servers-nix-plus/archive/main.tar.gz") { inherit pkgs; };
in
mcp-servers-nix.lib.mkConfig pkgs {
  programs.filesystem = {
    enable = true;
    args = [ "/path/to/allowed/directory" ];
  };
}
```

```bash
nix-build config.nix && cat result
```

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "/nix/store/7b4ancp3cns9lkkybd090qzr0hah5qq0-mcp-server-filesystem-2025.12.18/bin/mcp-server-filesystem",
      "args": ["/path/to/allowed/directory"]
    }
  }
}
```

The output format adapts to the `flavor` option — see
[Supported Flavors](#supported-flavors) below.

## Supported Flavors

| Flavor             | Key               | Typical File                 | Client              |
| ------------------ | ----------------- | ---------------------------- | ------------------- |
| `claude`           | `mcpServers`      | `claude_desktop_config.json` | Claude Desktop      |
| `claude-code`      | `mcpServers`      | `.mcp.json`                  | Claude Code         |
| `vscode`           | `mcp.servers`     | `settings.json`              | VS Code             |
| `vscode-workspace` | `servers`         | `.vscode/mcp.json`           | VS Code (workspace) |
| `codex`            | `mcp_servers`     | `.mcp.toml`                  | Codex CLI           |
| `opencode`         | `mcp`             | `opencode.json`              | OpenCode            |
| `zed`              | `context_servers` | (varies)                     | Zed                 |

## Available Modules

### Upstream (available in original mcp-servers-nix)

- [codex](./modules/servers/codex.nix)
- [context7](./modules/servers/context7.nix)
- [deepl](./modules/servers/deepl.nix)
- [esa](./modules/servers/esa.nix)
- [everything](./modules/servers/everything.nix)
- [fetch](./modules/servers/fetch.nix)
- [filesystem](./modules/servers/filesystem.nix)
- [freee](./modules/servers/freee.nix)
- [git](./modules/servers/git.nix)
- [github](./modules/servers/github.nix)
- [grafana](./modules/servers/grafana.nix)
- [home-assistant](./modules/servers/home-assistant.nix)
- [mastra](./modules/servers/mastra.nix)
- [memory](./modules/servers/memory.nix)
- [netdata](./modules/servers/netdata.nix)
- [nixos](./modules/servers/nixos.nix)
- [notion](./modules/servers/notion.nix)
- [playwright](./modules/servers/playwright.nix)
- [sequential-thinking](./modules/servers/sequential-thinking.nix)
- [serena](./modules/servers/serena.nix)
- [slite](./modules/servers/slite.nix)
- [tavily](./modules/servers/tavily.nix)
- [terraform](./modules/servers/terraform.nix)
- [textlint](./modules/servers/textlint.nix)
- [time](./modules/servers/time.nix)

### mcp-servers-nix-plus (not yet in upstream)

- [argocd](./modules/servers/argocd.nix) — MCP server for ArgoCD
- [chrome-devtools](./modules/servers/chrome-devtools.nix) — Chrome DevTools MCP
  server
- [fibery](./modules/servers/fibery.nix) — Fibery MCP server
- [google-calendar](./modules/servers/google-calendar.nix) — Google Calendar MCP
- [greenhouse](./modules/servers/greenhouse.nix) — Greenhouse Harvest API MCP
- [logseq](./modules/servers/logseq.nix) — LogSeq MCP server
- [signoz](./modules/servers/signoz.nix) — MCP server for the SigNoz
  observability platform

### mcp-servers-nix-plus packages (no module yet)

These are available as standalone packages (e.g.
`nix run github:antono/mcp-servers-nix-plus#ctxo`) but do not have a
configuration module yet:

- [ctxo](./pkgs/plus/ctxo) — Dependency-aware, history-enriched context for
  codebases
- [freecad-mcp](./pkgs/plus/freecad-mcp) — FreeCAD MCP server
- [lean-ctx](./pkgs/plus/lean-ctx) — Context runtime for AI agents (CCP + TDD)
 

## Examples

Check the `examples` directory for complete configuration examples:

- [`claude-desktop.nix`](./examples/claude-desktop.nix): Basic configuration for
  Claude Desktop
 
- [`vscode.nix`](./examples/vscode.nix): VS Code integration setup
- [`librechat.nix`](./examples/librechat.nix): Configuration for LibreChat
  integration
- [`codex.nix`](./examples/codex.nix): Codex CLI integration with MCP servers
- [`opencode.nix`](./examples/opencode.nix): OpenCode CLI integration with MCP
  servers
- [`vscode-workspace`](./examples/vscode-workspace/flake.nix): VS Code workspace
  configuration example
- [`flake-parts-module`](./examples/flake-parts-module/flake.nix): Flake-parts
  module integration with multi-flavor support
- [`devenv`](./examples/devenv): devenv integration using
  `claude.code.mcpServers`
- [`home-manager`](./examples/home-manager/flake.nix): Home Manager integration
  with `programs.mcp.servers`

### Real World Examples

Check out
[GitHub search results](https://github.com/search?q=lang%3Anix+mcp-servers-nix&type=code)
for examples of how others are using mcp-servers-nix in their projects.

## Documentation

- [Module Usage Guide](docs/module-usage.md) — How to configure MCP servers with
  Nix (classic, npins, flakes, flake-parts)
- [Configuration Reference](docs/configuration-reference.md) — Security,
  credential handling, and flake-parts options
- [Module Options Reference](docs/module-options.md) — Auto-generated list of
  all module options
- [Packages Guide](docs/packages.md) — Using standalone MCP server packages
- [Contributing Guide](CONTRIBUTING.md) — Adding new packages and modules

## License

This project is licensed under the Apache License 2.0 - see the
[LICENSE file](./LICENSE) for details.
