{ lib, config, ... }:
let
  cfg = config.programs.slite;
in
{
  imports = [
    (lib.mkRemovedOptionModule [ "programs" "slite" "package" ] ''
      slite-mcp-server (the stdio package) is no longer maintained upstream.
      The module now uses Slite's hosted MCP server at
      https://api.slite.com/mcp via streamable HTTP, so this option has no
      effect. Remove it from your configuration.
    '')
    (lib.mkRemovedOptionModule [ "programs" "slite" "useRemote" ] ''
      programs.slite.useRemote has been removed. The module now
      unconditionally uses Slite's hosted MCP server at
      https://api.slite.com/mcp. Remove it from your configuration.
    '')
    (lib.mkRemovedOptionModule [ "programs" "slite" "type" ] ''
      programs.slite.type has been removed. Slite's hosted MCP server only
      supports streamable HTTP, so the type is emitted as "http"
      unconditionally. Remove it from your configuration.
    '')
    (lib.mkRemovedOptionModule [ "programs" "slite" "args" ] ''
      programs.slite.args has been removed. The module no longer runs a
      local command (it talks to Slite's hosted MCP server over HTTP), so
      arguments have no effect. Remove it from your configuration.
    '')
    (lib.mkRemovedOptionModule [ "programs" "slite" "env" ] ''
      programs.slite.env has been removed. The `env` field is only
      meaningful for stdio MCP servers; remote HTTP clients (Claude
      Desktop/Code, VS Code, Codex) ignore it. Use programs.slite.headers
      (e.g. a Bearer token with a Slite API key) for authentication
      instead.
    '')
    (lib.mkRemovedOptionModule [ "programs" "slite" "envFile" ] ''
      programs.slite.envFile has been removed. It wrapped the local
      command with an env export, which no longer exists. Export
      credentials in your shell and reference them from
      programs.slite.headers with `''${VAR}` syntax instead.
    '')
    (lib.mkRemovedOptionModule [ "programs" "slite" "passwordCommand" ] ''
      programs.slite.passwordCommand has been removed. It wrapped the
      local command with a secret-fetching script, which no longer
      exists. Export credentials in your shell and reference them from
      programs.slite.headers with `''${VAR}` syntax instead.
    '')
    (lib.mkRemovedOptionModule [ "programs" "slite" "wrapPackageWithEnvFile" ] ''
      The option 'wrapPackageWithEnvFile' has been removed as it is no longer needed.
    '')
  ];

  options.programs.slite = {
    enable = lib.mkEnableOption "slite";

    url = lib.mkOption {
      type = lib.types.str;
      default = "https://api.slite.com/mcp";
      description = ''
        URL of the Slite MCP server.
      '';
    };

    headers = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = { };
      description = ''
        HTTP headers for authentication. Slite's hosted server uses OAuth
        by default (no headers required); a Slite API key can be supplied
        as a Bearer token instead.
        For security reasons, do not hardcode credentials in headers.
        Use variable expansion syntax (e.g., ''${VAR}) supported by the client.
        Set environment variables before launching the client instead.
      '';
      example = lib.literalExpression ''
        { Authorization = "Bearer \''${SLITE_API_TOKEN}"; }
      '';
    };
  };

  config.settings.servers = lib.mkIf cfg.enable {
    slite = {
      type = "http";
      inherit (cfg) url headers;
    };
  };
}
