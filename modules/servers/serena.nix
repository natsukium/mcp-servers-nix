{
  config,
  lib,
  mkServerModule,
  servers,
  ...
}:
let
  cfg = config.programs.serena;

  finalPackage =
    if cfg.extraPackages == [ ] then
      servers.serena
    else
      servers.serena.overrideAttrs (oldAttrs: {
        makeWrapperArgs = (oldAttrs.makeWrapperArgs or [ ]) ++ [
          "--prefix"
          "PATH"
          ":"
          (lib.makeBinPath cfg.extraPackages)
        ];
      });
in
{
  imports = [
    (mkServerModule {
      name = "serena";
      packageName = "serena";
    })
  ];

  options.programs.serena = {
    context = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "agent"
          "chatgpt"
          "claude-code"
          "codex"
          "desktop-app"
          "ide-assistant"
          "oaicompat-agent"
        ]
      );
      default = null;
      description = ''
        Built-in context name. See https://github.com/oraios/serena/tree/main/src/serena/resources/config/contexts for available contexts.
        If null, the default context will be used.
      '';
    };

    enableWebDashboard = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = ''
        Enable or disable the Serena web dashboard.
        If null, the default setting will be used.
      '';
    };

    extraPackages = lib.mkOption {
      type = with lib.types; listOf package;
      default = [ ];
      example = lib.literalExpression "[ pkgs.nixd pkgs.rust-analyzer ]";
      description = ''
        Extra packages available in the serena wrapper's PATH.
        This is useful for including language servers and other tools
        that serena needs to access.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.serena.package = lib.mkDefault finalPackage;

    settings.servers.serena = {
      args = [
        "start-mcp-server"
      ]
      ++ lib.optionals (cfg.context != null) [
        "--context"
        cfg.context
      ]
      ++ lib.optionals (cfg.enableWebDashboard != null) [
        "--enable-web-dashboard"
        (if cfg.enableWebDashboard then "true" else "false")
      ];
    };
  };
}
