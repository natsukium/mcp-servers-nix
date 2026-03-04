{
  config,
  lib,
  mkServerModule,
  ...
}:
let
  cfg = config.programs.github;
in
{
  imports = [
    (mkServerModule {
      name = "github";
      packageName = "github-mcp-server";
    })
  ];

  config.settings.servers = lib.mkIf cfg.enable {
    github = {
      args = [ "stdio" ];
    };
  };
}
