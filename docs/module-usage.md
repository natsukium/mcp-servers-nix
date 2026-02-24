# Module Usage Guide

## How Modules Work

The module system provides a declarative way to configure MCP servers. At its core:

1. **`mkConfig`** evaluates your module configuration and produces a configuration file (JSON, YAML, or TOML)
2. **`programs.<name>.enable`** activates a pre-configured module for a specific MCP server
3. **`flavor`** determines the output key structure (e.g., `mcpServers` for Claude, `mcp.servers` for VS Code)
4. **`format`** determines the output file format

For the complete list of options, see the [Module Options Reference](module-options.md) and [Configuration Reference](configuration-reference.md).

## Classic (without Flakes)

Create a configuration file:

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
  };
}
```

Build your configuration:

```bash
nix-build config.nix
```

The output is a configuration file in the Nix store:

```jsonc
// result
{
  "mcpServers": {
    "fetch": {
      "args": [],
      "command": "/nix/store/...-mcp-server-fetch-.../bin/mcp-server-fetch",
      "env": {}
    },
    "filesystem": {
      "args": [ "/path/to/allowed/directory" ],
      "command": "/nix/store/...-mcp-server-filesystem-.../bin/mcp-server-filesystem",
      "env": {}
    }
  }
}
```

## Using npins

[npins](https://github.com/andir/npins) provides reproducible dependency pinning without flakes.

Initialize npins and add dependencies:

```bash
npins init
npins add github natsukium mcp-servers-nix -b main
```

Create your configuration using the pinned version:

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
  };
}
```

Build your configuration:

```bash
nix-build config.nix
```

## Using Flakes

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

Build your configuration:

```bash
nix build
```

## Using Flake-Parts

If you're already using [flake-parts](https://flake.parts/), the flake-parts module provides multi-flavor support and automatic development shell setup.

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

        devShells.default = config.mcp-servers.devShell;
      };
    };
}
```

Key features:

- **Multi-flavor support**: Generate configurations for Claude Code (`.mcp.json`) and VS Code workspace (`.vscode/mcp.json`) simultaneously
- **Automatic development shell**: `config.mcp-servers.devShell` sets up symlinks to configuration files
- **GC root management**: `addGcRoot` (default: `true`) prevents garbage collection of config files and server packages
- **Per-flavor overrides**: Customize `programs` and `settings` per flavor

For the full list of flake-parts options, see [Configuration Reference](configuration-reference.md#flake-parts-module-options).

## Using devenv

If you're using [devenv](https://devenv.sh/), the devenv module integrates with devenv's built-in `claude.code.mcpServers` option. Instead of generating `.mcp.json` via shellHook, it outputs through devenv's native Claude Code support.

```yaml
# devenv.yaml
inputs:
  mcp-servers-nix:
    url: github:natsukium/mcp-servers-nix
```

```nix
# devenv.nix
{ inputs, pkgs, ... }:
{
  imports = [ inputs.mcp-servers-nix.devenvModules.default ];

  claude.code.enable = true;

  mcp-servers.programs = {
    filesystem = {
      enable = true;
      args = [ "." ];
    };
    playwright.enable = true;
    context7.enable = true;
  };
}
```

Key features:

- **Declarative interface**: Same `programs.<name>.enable` interface as the flake-parts module
- **Native devenv integration**: Outputs through `claude.code.mcpServers` — devenv handles `.mcp.json` generation
- **Credential wrapping**: `envFile` and `passwordCommand` work naturally since they produce Nix store paths

See [`examples/devenv`](../examples/devenv) for a complete example.

## Using Home Manager

If you're using [home-manager](https://github.com/nix-community/home-manager), the home-manager module integrates with home-manager's centralized `programs.mcp` infrastructure. It maps configurations to `programs.mcp.servers`, which individual programs (claude-code, opencode, codex, vscode) consume via `enableMcpIntegration`.

```nix
# home.nix
{ inputs, ... }:
{
  imports = [ inputs.mcp-servers-nix.homeManagerModules.default ];

  programs.mcp.enable = true;

  mcp-servers.programs = {
    filesystem = {
      enable = true;
      args = [ "/home/user/documents" ];
    };
    playwright.enable = true;
    context7.enable = true;
  };

  programs.claude-code = {
    enable = true;
    enableMcpIntegration = true;
  };
}
```

Key features:

- **Declarative interface**: Same `programs.<name>.enable` interface as the flake-parts and devenv modules
- **Native home-manager integration**: Outputs through `programs.mcp.servers` — each program handles its own config generation via `enableMcpIntegration`
- **Credential wrapping**: `envFile` and `passwordCommand` work naturally since they produce Nix store paths

See [`examples/home-manager`](../examples/home-manager) for a complete example.

## Adding Custom Servers

Add MCP servers not included in this repository via `settings.servers`:

```nix
mcp-servers.lib.mkConfig pkgs {
  format = "yaml";
  fileName = "config.yaml";

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

Custom servers are merged alongside module-configured servers in the output file.

## Integration Patterns

### Claude Code Project

Set up a development shell that symlinks the MCP configuration into your project:

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    mcp-servers-nix.url = "github:natsukium/mcp-servers-nix";
  };

  outputs = { nixpkgs, mcp-servers-nix, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux" ];
    in
    {
      devShells = forAllSystems (system:
        let pkgs = import nixpkgs { inherit system; };
        in {
          default = pkgs.mkShell {
            shellHook =
              let
                config = mcp-servers-nix.lib.mkConfig pkgs {
                  programs.playwright.enable = true;
                };
              in
              ''
                if [ -L ".mcp.json" ]; then
                  unlink .mcp.json
                fi
                ln -sf ${config} .mcp.json
              '';
          };
        });
    };
}
```

See [`examples/claude-code-project/flake.nix`](../examples/claude-code-project/flake.nix) for the full example.

### VS Code Workspace

Generate VS Code workspace MCP configuration with input prompts for secrets:

```nix
devShells = forAllSystems (system:
  let pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
  in {
    default = pkgs.mkShell {
      packages = [ pkgs.vscode ];
      shellHook =
        let
          config = mcp-servers-nix.lib.mkConfig pkgs {
            fileName = "mcp.json";
            flavor = "vscode-workspace";
            programs = {
              filesystem = {
                enable = true;
                args = [ "${toString (builtins.getEnv "PWD")}" ];
              };
              github = {
                enable = true;
                env.GITHUB_PERSONAL_ACCESS_TOKEN = "\${input:github_token}";
              };
            };
            settings.inputs = [
              {
                type = "promptString";
                id = "github_token";
                description = "GitHub Personal Access Token";
                password = true;
              }
            ];
          };
        in
        ''
          mkdir -p .vscode
          ln -sf ${config} .vscode/mcp.json
        '';
    };
  });
```

See [`examples/vscode-workspace/flake.nix`](../examples/vscode-workspace/flake.nix) for the full example.

### Multi-Client with Flake-Parts

Use the flake-parts module to generate configurations for multiple clients at once:

```nix
perSystem = { config, pkgs, ... }: {
  mcp-servers = {
    # Base configuration for all flavors
    programs = {
      playwright.enable = true;
      filesystem = {
        enable = true;
        args = [ ".." ];
      };
    };

    settings.servers = {
      obsidian = {
        command = "${pkgs.nodejs}/bin/npx";
        args = [ "-y" "mcp-obsidian" "." ];
      };
    };

    # Flavor-specific overrides
    flavors = {
      claude-code = {
        enable = true;
        programs.filesystem.args = [ "../.." ];
      };
      vscode-workspace = {
        enable = true;
        programs.playwright.env.CUSTOM_SETTING = "vscode-value";
      };
    };
  };

  devShells.default = config.mcp-servers.devShell;
};
```

See [`examples/flake-parts-module/flake.nix`](../examples/flake-parts-module/flake.nix) for the full example.
