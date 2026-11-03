{
  config,
  lib,
  mkServerModule,
  ...
}:
let
  cfg = config.programs.k8s;
in
{
  imports = [
    (mkServerModule {
      name = "k8s";
      packageName = "mcp-k8s-go";
    })
  ];

  options.programs.k8s = {
    readOnly = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Disable write operations to the cluster.
      '';
    };

    allowedContexts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Restrict access to specified Kubernetes contexts.
        Empty list means all contexts are allowed.
      '';
    };

    maskSecrets = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Mask sensitive data in output.
      '';
    };
  };

  config.settings.servers = lib.mkIf cfg.enable {
    k8s = {
      args =
        lib.optionals cfg.readOnly [
          "--readonly"
        ]
        ++ lib.optionals (cfg.allowedContexts != [ ]) [
          "--allowed-contexts=${lib.concatStringsSep "," cfg.allowedContexts}"
        ]
        ++ lib.optionals (!cfg.maskSecrets) [
          "--mask-secrets=false"
        ];
    };
  };
}
