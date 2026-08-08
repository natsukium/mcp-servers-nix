{ config, lib, mkServerModule, ... }:
let
  cfg = config.programs.fibery;
in
{
  imports = [
    (mkServerModule {
      name = "fibery";
      packageName = "fibery-mcp-server";
    })
  ];

  options.programs.fibery = {
    host = lib.mkOption {
      type = lib.types.str;
      description = "Fibery host (e.g., your-domain.fibery.io)";
    };
    apiToken = lib.mkOption {
      type = lib.types.str;
      description = "Fibery API token";
    };
  };

  config.settings.servers = lib.mkIf cfg.enable {
    fibery = {
      args = [
        "stdio"
        "--fibery-host"
        cfg.host
        "--fibery-api-token"
        cfg.apiToken
      ];
    };
  };
}
