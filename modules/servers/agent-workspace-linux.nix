{
  config,
  lib,
  mkServerModule,
  ...
}:
let
  cfg = config.programs.agent-workspace-linux;
in
{
  imports = [
    (mkServerModule {
      name = "agent-workspace-linux";
      packageName = "agent-workspace-linux";
    })
  ];

  options.programs.agent-workspace-linux = {
    headless = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Run without any host-visible UI: the GPUI monitor that otherwise
        opens alongside non-headless workspaces is never launched.
      '';
    };

    permissions = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to a permissions JSON file setting a spawn-time ceiling (e.g. an
        app allowlist) that MCP clients can only narrow.
        See `agent-workspace-linux permissions template open`.
      '';
    };
  };

  config.settings.servers = lib.mkIf cfg.enable {
    agent-workspace-linux = {
      args = [
        "mcp"
      ]
      ++ lib.optionals (cfg.permissions != null) [
        "--permissions"
        "${cfg.permissions}"
      ]
      ++ lib.optional cfg.headless "--headless";
    };
  };
}
