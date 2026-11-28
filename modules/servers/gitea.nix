{
  config,
  lib,
  mkServerModule,
  ...
}:
let
  cfg = config.programs.gitea;
in
{
  imports = [
    (mkServerModule {
      name = "gitea";
      packageName = "gitea-mcp-server";
    })
  ];

  options.programs.gitea = {
    host = lib.mkOption {
      type = lib.types.str;
      default = "https://gitea.com";
      description = ''
        URL of the Gitea instance.
      '';
    };

    readOnly = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable read-only mode.
      '';
    };
  };

  config.settings.servers = lib.mkIf cfg.enable {
    gitea = {
      args = [
        "-host"
        cfg.host
      ]
      ++ lib.optionals cfg.readOnly [
        "-read-only"
      ];
    };
  };
}
