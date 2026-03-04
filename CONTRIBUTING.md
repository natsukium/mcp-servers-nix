# Contributing to mcp-servers-nix

## Project Structure

```
.
├── flake.nix            # Flake entry point
├── default.nix          # Classic Nix entry point
├── lib/                 # Core library (mkConfig, evalModule, mkServerModule)
├── modules/
│   ├── flake-parts.nix  # Flake-parts integration module
│   ├── devenv.nix       # devenv integration module
│   └── servers/         # Module definitions for each MCP server
├── pkgs/                # Package definitions
│   ├── official/        # Upstream official server packages
│   ├── reference/       # Reference implementation packages
│   └── community/       # Community server packages
├── tests/               # Automated tests
├── examples/            # Example configurations
├── overlays/            # Nixpkgs overlays
└── docs/                # Documentation
```

## Adding a New Package

### Package Categories

| Directory | Description |
|-----------|-------------|
| `pkgs/official/` | Packages from the server's upstream maintainers |
| `pkgs/reference/` | Packages from the MCP reference implementation |
| `pkgs/community/` | Packages from third-party community authors |

### Example: Adding a New Package

Create a package definition in the appropriate directory (e.g., `pkgs/official/new-mcp-server/default.nix`):

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

## Adding a Module

Modules live in `modules/servers/` and define how an MCP server is configured. The `mkServerModule` helper provides a consistent set of options (enable, package, args, env, url, headers, envFile, passwordCommand) for every server.

### Basic Module

For servers that need no special configuration beyond the standard options:

```nix
# modules/servers/new-mcp-server.nix
{ mkServerModule, ... }:
{
  imports = [ (mkServerModule { name = "new-mcp-server"; }) ];
}
```

The `name` parameter maps to `programs.<name>`, and the package defaults to `mcp-server-<name>`. Use `packageName` if the package name differs.

### Module with Args Override

When a server requires fixed arguments:

```nix
# modules/servers/github.nix
{ config, lib, mkServerModule, ... }:
let
  cfg = config.programs.github;
in
{
  imports = [
    (mkServerModule {
      name = "github";
      packageName = "github-mcp-server";
    })
  ];

  config.settings.servers = lib.mkIf cfg.enable {
    github = {
      args = [ "stdio" ];
    };
  };
}
```

### Module with Custom Options

For servers that expose additional configuration:

```nix
# modules/servers/playwright.nix
{ config, pkgs, lib, mkServerModule, ... }:
let
  cfg = config.programs.playwright;
in
{
  imports = [
    (mkServerModule {
      name = "playwright";
      packageName = "playwright-mcp";
    })
  ];

  options.programs.playwright = {
    executable = lib.mkOption {
      type = lib.types.path;
      default =
        if pkgs.stdenv.hostPlatform.isDarwin then
          lib.getExe pkgs.google-chrome
        else
          lib.getExe pkgs.chromium;
    };
  };

  config.settings.servers = lib.mkIf cfg.enable {
    playwright = {
      args = [
        "--executable-path"
        cfg.executable
      ];
    };
  };
}
```

### Complex Module

For servers with validation, dynamic packages, or generated configuration files, see [`modules/servers/textlint.nix`](./modules/servers/textlint.nix) as a reference. It demonstrates:

- Conditional package composition (`withPackages`)
- Generated configuration files from Nix attributes
- Assertions for required options

### Real-World Examples by Complexity

| Complexity | Example | Key Pattern |
|-----------|---------|-------------|
| Minimal | [`modules/servers/fetch.nix`](./modules/servers/fetch.nix) | `mkServerModule` only |
| Args override | [`modules/servers/github.nix`](./modules/servers/github.nix) | Fixed arguments |
| Custom options | [`modules/servers/playwright.nix`](./modules/servers/playwright.nix) | Platform-dependent defaults |
| Complex | [`modules/servers/textlint.nix`](./modules/servers/textlint.nix) | Dynamic packages, assertions, generated config |

## Testing

Run the test suite to verify your changes:

```bash
# Without flakes
nix-build tests

# With flakes
nix flake check
```

The check suite includes:
- Module evaluation tests in `tests/`
- Example build verification from `examples/`
- Package builds
- Module options documentation freshness check

## Updating Module Options Documentation

The [Module Options Reference](docs/module-options.md) is auto-generated from the module definitions. After changing any module options, regenerate it:

```bash
nix-build docs/options-doc.nix -A optionsCommonMark && install -m 644 result docs/module-options.md
```

The CI check `module-options-doc` will fail if the committed file is out of date.
