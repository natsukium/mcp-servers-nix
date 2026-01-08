# OpenCode configuration example
# Generates ~/.config/opencode/opencode.json format
#
# OpenCode MCP format differences from Claude:
# - Root key: "mcp" (not "mcpServers")
# - command: array including args (not separate command + args)
# - environment: (not "env")
# - type: "local" or "remote" (not "stdio"/"http"/"sse")
# - enabled: boolean field
#
# Usage: nix-build examples/opencode.nix
# Result will contain opencode.json
{
  pkgs ? import <nixpkgs> { },
}:
let
  mcp-servers = import ../. { inherit pkgs; };
in
mcp-servers.lib.mkConfig pkgs {
  flavor = "opencode";
  fileName = "opencode.json";

  programs = {
    # Local MCP server example
    filesystem = {
      enable = true;
      args = [ "/path/to/allowed/directory" ];
    };

    # Server with environment variables
    fetch = {
      enable = true;
    };

    # NixOS documentation server
    nixos = {
      enable = true;
    };
  };

  # Extra settings that will be merged into the config
  # OpenCode supports additional config like keybinds, lsp, etc.
  settings = {
    "$schema" = "https://opencode.ai/config.json";
  };
}
