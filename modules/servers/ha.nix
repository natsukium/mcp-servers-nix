{
  config,
  lib,
  mkServerModule,
  ...
}:
let
  cfg = config.programs.ha;
in
{
  imports = [
    (mkServerModule {
      name = "ha";
      packageName = "ha-mcp";
    })
  ];

  options.programs.ha = {
    enabledToolModules = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "all"
          "automation"
          "search"
          "device_control"
        ]
      );
      default = [ ];
      description = ''
        Filter which tool modules are available.
        Empty list means all modules are enabled.
      '';
    };
  };

  config.settings.servers = lib.mkIf cfg.enable {
    ha = {
      env = lib.mkIf (cfg.enabledToolModules != [ ]) {
        ENABLED_TOOL_MODULES = lib.concatStringsSep "," cfg.enabledToolModules;
      };
    };
  };
}
