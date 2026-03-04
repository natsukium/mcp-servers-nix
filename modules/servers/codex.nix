{
  config,
  pkgs,
  lib,
  mkServerModule,
  ...
}:
let
  cfg = config.programs.codex;
in
{
  imports = [
    (mkServerModule {
      name = "codex";
      packageName = "codex";
    })
  ];

  config.settings.servers = lib.mkIf cfg.enable {
    codex = {
      args = [ "mcp-server" ];
    };
  };
}
