{
  config,
  lib,
  mkServerModule,
  ...
}:
let
  cfg = config.programs.computer-use-linux;
in
{
  imports = [
    (mkServerModule {
      name = "computer-use-linux";
      packageName = "computer-use-linux";
    })
  ];

  config.settings.servers = lib.mkIf cfg.enable {
    computer-use-linux = {
      args = [ "mcp" ];
    };
  };
}
