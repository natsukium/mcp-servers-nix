# Home Manager module that bridges mcp-servers-nix's declarative module system
# with home-manager's programs.mcp.servers configuration.
#
# Instead of generating config files directly, this outputs through
# home-manager's centralized MCP infrastructure where individual programs
# (claude-code, opencode, codex, vscode) consume servers via enableMcpIntegration.
{
  config,
  pkgs,
  lib,
  ...
}:
let
  mcp-lib = import ../lib;
  cfg = config.mcp-servers;

  evaluated = mcp-lib.evalModule pkgs {
    inherit (cfg) programs settings;
    # "claude" flavor produces a generic format that matches programs.mcp.servers
    flavor = "claude";
  };

  servers = evaluated.config.settings.servers or { };

  # home-manager infers transport type from presence of command (→ stdio) vs url (→ http/remote)
  transformServer =
    _name: server:
    lib.filterAttrs (_: v: v != null && v != [ ] && v != { }) (
      lib.removeAttrs (
        lib.optionalAttrs (server ? command) {
          inherit (server) command;
        }
        // lib.optionalAttrs (server ? args && server.args != [ ]) {
          args = map toString server.args;
        }
        // lib.optionalAttrs (server ? env && server.env != { }) {
          env = lib.mapAttrs (_: toString) server.env;
        }
        // lib.optionalAttrs (server ? url) {
          inherit (server) url;
        }
        // lib.optionalAttrs (server ? headers && server.headers != { }) {
          inherit (server) headers;
        }
      ) [ "type" ]
    );
in
{
  options.mcp-servers = {
    programs = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = ''
        MCP server program configurations.
        Uses the same interface as the flake-parts module.
      '';
      example = lib.literalExpression ''
        {
          playwright.enable = true;
          filesystem = {
            enable = true;
            args = [ "." ];
          };
        }
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = (pkgs.formats.json { }).type;
      };
      default = { };
      description = ''
        Additional freeform configuration for MCP servers.
      '';
    };
  };

  config = lib.mkIf (servers != { }) {
    programs.mcp.servers = lib.mapAttrs transformServer servers;
  };
}
