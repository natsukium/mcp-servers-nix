# mcp-servers-nix

A Nix-based configuration framework for Model Control Protocol (MCP) servers with ready-to-use packages.

## Overview

This repository provides both MCP server packages and a Nix framework for configuring and deploying MCP servers. It offers a modular approach to configuring various MCP servers with a consistent interface.

## Features

- **Modular Configuration**: Define and combine multiple MCP server configurations
- **Reproducible Builds**: Leverage Nix for reproducible and declarative server setups
- **Pre-configured Modules**: Ready-to-use configurations for popular MCP server types
- **Security-focused**: Better handling credentials and sensitive information through `envFile` and `passwordCommand`, with pinned server versions

## Getting Started

### Quick Usage Without Installation

You can run MCP server packages directly without installing them:

```bash
# Using nix-shell
nix-shell -p "(import (builtins.fetchTarball \"https://github.com/natsukium/mcp-servers-nix/archive/main.tar.gz\") {}).mcp-server-fetch" --run mcp-server-fetch

# Using flakes
nix run github:natsukium/mcp-servers-nix#mcp-server-fetch
```

### Installing Packages

There are several ways to install and use the packages provided by this repository:

#### Direct Package Installation

You can install individual MCP server packages directly with:

```bash
# Without flakes
nix-env -f https://github.com/natsukium/mcp-servers-nix/archive/main.tar.gz -iA mcp-server-fetch

# Using flakes
nix profile install github:natsukium/mcp-servers-nix#mcp-server-fetch
```

#### Using Overlays

You can use the provided overlays to add all MCP server packages to your pkgs:

```nix
# In your configuration.nix or home.nix
{
  nixpkgs.overlays = [
    # classic
    (import (builtins.fetchTarball "https://github.com/natsukium/mcp-servers-nix/archive/main.tar.gz")).overlays.default
    # or with flakes
    # mcp-servers-nix.overlays.default 
  ];

  # Then you can install packages through `pkgs`
  environment.systemPackages = with pkgs; [
    mcp-server-fetch
  ];
}
```

### Module Usage

#### Classic approach without flakes

1. Create a configuration file:

```nix
# config.nix
let
  pkgs = import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/refs/heads/nixos-unstable.tar.gz") { };
  mcp-servers = import (builtins.fetchTarball "https://github.com/natsukium/mcp-servers-nix/archive/refs/heads/main.tar.gz") { inherit pkgs; };
in
mcp-servers.lib.mkConfig pkgs {
  programs = {
    filesystem = {
      enable = true;
      args = [ "/path/to/allowed/directory" ];
    };
    fetch.enable = true;
    # Add more modules as needed
  };
}
```

2. Build your configuration:

```bash
nix-build config.nix
```

```jsonc
// result
{
  "mcpServers": {
    "fetch": {
      "args": [],
      "command": "/nix/store/dbx03yjf6h14h5rvdppzj2fyhfjpx99g-mcp-server-fetch-2025.3.28/bin/mcp-server-fetch",
      "env": {}
    },
    "filesystem": {
      "args": [ "/path/to/allowed/directory" ],
      "command": "/nix/store/i0v4ynavmz3iilr27c7iqg4dc3xxnygb-mcp-server-filesystem-2025.3.28/bin/mcp-server-filesystem",
      "env": {}
    }
  }
}
```

#### Using npins

[npins](https://github.com/andir/npins) is a simple dependency pinning tool that allows you to guarantee reproducible builds without using flakes:

1. Initialize npins in your project:

```bash
npins init
```

2. Add mcp-servers-nix as a dependency:

```bash
npins add github natsukium mcp-servers-nix -b main
```

3. Create your configuration using the pinned version:

```nix
# config.nix
let
  sources = import ./npins;
  pkgs = import sources.nixpkgs {};
  mcp-servers = import sources.mcp-servers-nix {};
in
mcp-servers.lib.mkConfig pkgs {
  programs = {
    filesystem = {
      enable = true;
      args = [ "/path/to/allowed/directory" ];
    };
    fetch.enable = true;
    # Add more modules as needed
  };
}
```

4. Build your configuration:

```bash
nix-build config.nix
```

#### Using Flakes

1. Create a configuration file:

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    mcp-servers-nix.url = "github:natsukium/mcp-servers-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      mcp-servers-nix,
    }:
    {
      packages.x86_64-linux.default =
        let
          pkgs = import nixpkgs { system = "x86_64-linux"; };
        in
        mcp-servers-nix.lib.mkConfig pkgs {
          programs = {
            filesystem = {
              enable = true;
              args = [ "/path/to/allowed/directory" ];
            };
            fetch.enable = true;
          };
        };
    };
}
```

2. Build your configuration:

```bash
nix build
```

#### Using Flake-Parts Module

If you're already using [flake-parts](https://flake.parts/) in your project, you can integrate mcp-servers-nix as a flake-parts module for a more seamless experience.

1. Add the flake module to your imports:

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    mcp-servers-nix.url = "github:natsukium/mcp-servers-nix";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.mcp-servers-nix.flakeModule ];

      perSystem = { config, ... }: {
        mcp-servers = {
          programs.playwright.enable = true;
          flavors.claude-code.enable = true;
        };

        # Use the generated development shell
        devShells.default = config.mcp-servers.devShell;
      };
    };
}
```

Key features of the flake-parts module:

- **Multi-flavor support**: Generate configurations for Claude Code (`.mcp.json`) and VSCode workspace (`.vscode/mcp.json`) simultaneously using the `flavors` option
- **Automatic development shell**: Access `config.mcp-servers.devShell` which sets up symlinks to configuration files automatically
- **Per-flavor configuration**: Customize settings for each client using `flavors.<flavor>.programs` and `flavors.<flavor>.settings`

For a complete example with multiple flavors, see [`flake-parts-module`](./examples/flake-parts-module/flake.nix).

## Examples

Check the `examples` directory for complete configuration examples:

- [`claude-desktop.nix`](./examples/claude-desktop.nix): Basic configuration for Claude Desktop
- [`vscode.nix`](./examples/vscode.nix): VS Code integration setup
- [`librechat.nix`](./examples/librechat.nix): Configuration for LibreChat integration
- [`codex.nix`](./examples/codex.nix): Codex CLI integration with MCP servers
- [`vscode-workspace`](./examples/vscode-workspace/flake.nix): VS Code workspace configuration example
- [`flake-parts-module`](./examples/flake-parts-module/flake.nix): Flake-parts module integration with multi-flavor support

### Real World Examples

Check out [GitHub search results](https://github.com/search?q=lang%3Anix+mcp-servers-nix&type=code) for examples of how others are using mcp-servers-nix in their projects.

## Configuration Options

Each module provides specific configuration options, but there are some common options available for all modules:

### Global Options

- `format`: Configuration file format (`json`, `yaml`, or `toml-inline`, default: `json`)
- `flavor`: Configuration file type (`claude`, `vscode`, or `codex`, default: `claude`)
- `fileName`: Configuration file name (default: `claude_desktop_config.json`)
- `settings`: Custom settings that will be merged with the generated configuration

### Common Module Options

Each enabled module (using `programs.<module>.enable = true;`) provides the following options:

- `package`: The package to use for this module
- `type`: Server connection type (`sse` or `stdio`, default: `null`)
- `args`: Array of arguments passed to the command (default: `[]`)
- `env`: Environment variables for the server (default: `{}`)
- `url`: URL of the server for "sse" connections (default: `null`)
- `envFile`: Path to an .env file from which to load additional environment variables (default: `null`)
- `passwordCommand`: Command to execute to retrieve secrets. Can be specified as a string that outputs in the format "KEY=VALUE" which will be exported as environment variables, or as an attribute set where keys are environment variable names and values are command lists that output the value. Useful for integrating with password managers (default: `null`)

### Security Note

For security reasons, do not hardcode authentication credentials in the `env` attribute. All files in `/nix/store` can be read by anyone with access to the store. Always use `envFile` or `passwordCommand` instead.

The system automatically wraps the package when either `envFile` or `passwordCommand` is set, which allows secure retrieval of credentials without exposing them in the Nix store.

## Available Modules

The framework includes modules for the following MCP servers:

- [clickup](./modules/clickup.nix)
- [codex](./modules/codex.nix)
- [context7](./modules/context7.nix)
- [everything](./modules/everything.nix)
- [fetch](./modules/fetch.nix)
- [filesystem](./modules/filesystem.nix)
- [git](./modules/git.nix)
- [github](./modules/github.nix)
- [grafana](./modules/grafana.nix)
- [memory](./modules/memory.nix)
- [nixos](./modules/nixos.nix)
- [notion](./modules/notion.nix)
- [playwright](./modules/playwright.nix)
- [sequential-thinking](./modules/sequential-thinking.nix)
- [serena](./modules/serena.nix)
- [terraform](./modules/terraform.nix)
- [time](./modules/time.nix)

## Adding Custom Servers

You can add your own custom MCP servers by configuring them directly in the `settings.servers` section. This is useful for integrating MCP servers that are not included in this repository.

### Example: Adding Obsidian Integration

Here's an example of how to add the `mcp-obsidian` server to integrate with Obsidian:

```nix
mcp-servers.lib.mkConfig pkgs {
  format = "yaml";
  fileName = "config.yaml";
  
  # Configure built-in modules
  programs = {
    filesystem = {
      enable = true;
      args = [ "/path/to/allowed/directory" ];
    };
  };
  
  # Add custom MCP servers
  settings.servers = {
    mcp-obsidian = {
      command = "${pkgs.lib.getExe' pkgs.nodejs "npx"}";
      args = [
        "-y"
        "mcp-obsidian"
        "/path/to/obsidian/vault"
      ];
    };
  };
}
```

This approach allows you to integrate any MCP-compatible server into your configuration without needing to create a dedicated module.

Refer to individual module source files in the `modules/` directory for module-specific configuration options.

## Adding New MCP Servers

You can extend mcp-servers-nix with new MCP servers by adding both package definitions and module configurations.

### Package Structure

1. Official packages go in `pkgs/official/`
2. Reference implementations go in `pkgs/reference/`
3. Community implementations go in `pkgs/community/`

### Example: Adding a New Official Server Package

Create a new package definition in `pkgs/official/new-mcp-server/default.nix`:

```nix
{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage rec {
  pname = "new-mcp-server";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "new-mcp-server";
    repo = "new-mcp-server";
    tag = "v${version}";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
  };

  npmDepsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";

  meta = {
    description = "New MCP server";
    homepage = "https://github.com/new-mcp-server/new-mcp-server";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ username ];
    mainProgram = "new-mcp-server";
  };
}
```

Then register it in `pkgs/default.nix`:

```nix
{
  # ... existing packages ...
  
  # new server
  new-mcp-server = pkgs.callPackage ./official/new-mcp-server { };
}
```

### Module Configuration

Create a new module in `modules/new-mcp-server.nix`:

```nix
{ mkServerModule, ... }:
{
  imports = [
    (mkServerModule {
      name = "new-mcp-server";
      packageName = "new-mcp-server";
    })
  ];
}
```

The [`mkServerModule` function](lib/default.nix) provides the framework for creating module configurations with consistent options. See its implementation for more details about available features.

### Adding Custom Module Options

In addition to the common options provided by `mkServerModule`, you can define custom options for your module. This allows you to expose server-specific configuration that can be set by users.

```nix
{ config, pkgs, lib, mkServerModule, ... }:
let
  cfg = config.programs.new-mcp-server;
in
{
  imports = [
    (mkServerModule {
      name = "new-mcp-server";
      packageName = "new-mcp-server";
    })
  ];

  # Define custom options for this module
  options.programs.new-mcp-server = {
    customOption = lib.mkOption {
      type = lib.types.str;
      default = "default-value";
      description = ''
        Description of the custom option
      '';
    };
    
    binaryPath = lib.mkOption {
      type = lib.types.path;
      default = lib.getExe pkgs.some-package;
      description = ''
        Path to the binary required by the server
      '';
    };
  };

  # Use custom options to modify the server configuration
  config.settings.servers = lib.mkIf cfg.enable {
    new-mcp-server = {
      args = [
        "--option"
        cfg.customOption
        "--binary-path"
        cfg.binaryPath
      ];
    };
  };
}
```

For more complex servers, you can examine the existing implementations in the `pkgs/` and `modules/` directories as reference.

## Testing

This repository includes automated tests to verify the functionality of the framework. You can run the tests using the following commands:

```bash
# without flakes
nix-build tests

# with flakes
nix flake check
```

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE file](./LICENSE) for details.
