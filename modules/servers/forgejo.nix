{
  config,
  lib,
  mkServerModule,
  ...
}:
let
  cfg = config.programs.forgejo;
in
{
  imports = [
    (mkServerModule {
      name = "forgejo";
      packageName = "forgejo-mcp";
    })
  ];

  options.programs.forgejo = {
    instanceUrl = lib.mkOption {
      type = lib.types.str;
      description = ''
        URL of the Forgejo instance.
      '';
      example = "https://codeberg.org";
    };
  };

  config.settings.servers = lib.mkIf cfg.enable {
    forgejo = {
      args = [
        "--url"
        cfg.instanceUrl
      ];
    };
  };
}
