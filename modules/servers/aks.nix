{
  config,
  lib,
  mkServerModule,
  ...
}:
let
  cfg = config.programs.aks;
in
{
  imports = [
    (mkServerModule {
      name = "aks";
      packageName = "aks-mcp-server";
    })
  ];

  options.programs.aks = {
    accessLevel = lib.mkOption {
      type = lib.types.enum [
        "readonly"
        "readwrite"
        "admin"
      ];
      default = "readonly";
      description = ''
        Access level for AKS operations.
      '';
    };

    enabledComponents = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "az_cli"
          "monitor"
          "fleet"
          "network"
          "compute"
          "detectors"
          "advisor"
          "inspektorgadget"
          "kubectl"
          "helm"
          "cilium"
          "hubble"
        ]
      );
      default = [ ];
      description = ''
        List of enabled components. Empty list means all components are enabled.
      '';
    };
  };

  config.settings.servers = lib.mkIf cfg.enable {
    aks = {
      args = [
        "--access-level"
        cfg.accessLevel
      ]
      ++ lib.optionals (cfg.enabledComponents != [ ]) [
        "--enabled-components"
        (lib.concatStringsSep "," cfg.enabledComponents)
      ];
    };
  };
}
