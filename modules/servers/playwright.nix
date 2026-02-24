{
  config,
  pkgs,
  lib,
  mkServerModule,
  ...
}:
let
  cfg = config.programs.playwright;
in
{
  imports = [
    (mkServerModule {
      name = "playwright";
      packageName = "playwright-mcp";
    })
  ];

  options.programs.playwright = {
    executable = lib.mkOption {
      type = lib.types.path;
      default =
        if pkgs.stdenv.hostPlatform.isDarwin then
          lib.getExe pkgs.google-chrome
        else
          lib.getExe pkgs.chromium;
      defaultText = lib.literalExpression ''
        if pkgs.stdenv.hostPlatform.isDarwin then
          lib.getExe pkgs.google-chrome
        else
          lib.getExe pkgs.chromium
      '';
    };
  };

  config.settings.servers = lib.mkIf cfg.enable {
    playwright = {
      args = [
        "--executable-path"
        cfg.executable
      ];
    };
  };
}
