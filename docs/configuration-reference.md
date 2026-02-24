# Configuration Reference

## Module Options

For a complete list of all module options (global options, common per-server options, and server-specific options), see the auto-generated [Module Options Reference](module-options.md).

## Security

### Credential Handling

All files in `/nix/store` are world-readable. **Never hardcode credentials** in `env` or `headers` attributes — they will be stored in plain text in the Nix store.

### envFile

Use `envFile` to load environment variables from a file at runtime:

```nix
programs.github = {
  enable = true;
  envFile = /path/to/secrets/.env;
};
```

The `.env` file should contain `KEY=VALUE` pairs, one per line. Lines starting with `#` are treated as comments.

When `flavor` is set to `"vscode"`, the env file path is passed directly to VS Code as a parameter. For all other flavors, the package is wrapped with a script that exports the variables before launching.

### passwordCommand

Use `passwordCommand` to retrieve secrets from password managers or other tools at runtime.

**String form** — the command should output `KEY=VALUE` lines:

```nix
programs.github = {
  enable = true;
  passwordCommand = "pass mcp/github";
};
```

**Attribute set form** — keys are variable names, values are command lists:

```nix
programs.github = {
  enable = true;
  passwordCommand = {
    GITHUB_PERSONAL_ACCESS_TOKEN = [ "gh" "auth" "token" ];
  };
};
```

`passwordCommand` always wraps the package regardless of flavor.

### Headers with Client-Side Variable Expansion

For `http` and `sse` transport types, use variable expansion syntax supported by the client instead of hardcoding credentials in `headers`:

```nix
programs.some-server = {
  enable = true;
  type = "sse";
  url = "https://api.example.com/mcp";
  headers = {
    Authorization = "Bearer \${API_TOKEN}";
  };
};
```

Set the environment variable (`API_TOKEN` in this case) before launching the client. Note that `passwordCommand` only works with `stdio` servers since `http`/`sse` servers are not wrapped.

## Flake-Parts Module Options

The [flake-parts](https://flake.parts/) module (`flakeModule`) provides options under `perSystem.mcp-servers`. These are separate from the core module options — they orchestrate multi-flavor configuration and development shell setup.

### programs

```
perSystem.mcp-servers.programs
```

Base MCP server configuration applied to all enabled flavors. Same structure as the core module's `programs`.

```nix
mcp-servers.programs = {
  playwright.enable = true;
  github.enable = true;
};
```

### settings

```
perSystem.mcp-servers.settings
```

Additional freeform configuration applied to all enabled flavors. Use `settings.servers` to add custom MCP servers.

```nix
mcp-servers.settings.servers = {
  obsidian = {
    command = "${pkgs.nodejs}/bin/npx";
    args = [ "-y" "mcp-obsidian" "/path/to/vault" ];
  };
};
```

### addGcRoot

```
perSystem.mcp-servers.addGcRoot
```

**Type:** `bool` **Default:** `true`

Whether to add generated config files to garbage collector roots. Prevents `nix-collect-garbage` from removing configuration files and the MCP server packages they reference.

### flavors.\<name\>

```
perSystem.mcp-servers.flavors.<name>.{enable, programs, settings}
```

Per-flavor configuration. Currently supported flavors: `claude-code` and `vscode-workspace`.

- `enable`: Enable configuration generation for this flavor
- `programs`: Override base programs for this flavor (recursively merged)
- `settings`: Override base settings for this flavor (recursively merged)

```nix
mcp-servers.flavors = {
  claude-code = {
    enable = true;
    programs.filesystem.args = [ "../.." ];
  };
  vscode-workspace = {
    enable = true;
    programs.playwright.env.CUSTOM_SETTING = "vscode-value";
  };
};
```

### Read-Only Outputs

These are computed from the configuration above and can be consumed in your flake:

| Option | Type | Description |
|--------|------|-------------|
| `configs` | `attrsOf package` | Generated configuration files for each enabled flavor |
| `packages` | `listOf package` | All enabled MCP server packages |
| `shellHook` | `str` | Shell hook that creates symlinks for enabled flavor configs |
| `devShell` | `package` | Development shell with MCP server packages and config setup |

```nix
# Use the generated devShell directly
devShells.default = config.mcp-servers.devShell;

# Or compose with your own
devShells.default = pkgs.mkShell {
  buildInputs = [ pkgs.nodejs ] ++ config.mcp-servers.packages;
  shellHook = config.mcp-servers.shellHook + ''
    echo "MCP servers configured!"
  '';
};
```

## devenv Module Options

The devenv module (`devenvModules.default`) provides `mcp-servers.programs` and `mcp-servers.settings` options — the same interface as the [flake-parts module](#flake-parts-module-options). It maps configurations to devenv's native `claude.code.mcpServers`.
