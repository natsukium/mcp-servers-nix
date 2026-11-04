{
  config,
  lib,
  mkServerModule,
  ...
}:
let
  cfg = config.programs.fluxcd-operator;
in
{
  imports = [
    (mkServerModule {
      name = "fluxcd-operator";
      packageName = "fluxcd-operator-mcp";
    })
  ];

  options.programs.fluxcd-operator = {
    readOnly = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Disable write/delete operations.
      '';
    };

    maskSecrets = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Mask sensitive data in server output.
      '';
    };

    namespace = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Target Kubernetes namespace.
      '';
    };

    kubeContext = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Specific Kubernetes context to use.
      '';
    };
  };

  config.settings.servers = lib.mkIf cfg.enable {
    fluxcd-operator = {
      # flux-operator-mcp requires the "serve" subcommand to start the MCP server
      args = [
        "serve"
      ]
      ++ lib.optionals cfg.readOnly [
        "--read-only"
      ]
      ++ lib.optionals (!cfg.maskSecrets) [
        "--mask-secrets=false"
      ]
      ++ lib.optionals (cfg.namespace != null) [
        "--namespace"
        cfg.namespace
      ]
      ++ lib.optionals (cfg.kubeContext != null) [
        "--kube-context"
        cfg.kubeContext
      ];
    };
  };
}
