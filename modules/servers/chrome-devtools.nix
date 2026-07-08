{
  config,
  pkgs,
  lib,
  mkServerModule,
  ...
}:
let
  cfg = config.programs.chrome-devtools;
in
{
  imports = [
    (mkServerModule {
      name = "chrome-devtools";
      packageName = "chrome-devtools-mcp";
    })
  ];

  options.programs.chrome-devtools = {
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
      description = ''
        Path to the Chrome or Chromium executable the server launches.

        The server does not ship a browser, and its default channel lookup
        relies on FHS paths that do not exist on NixOS, so a Nix-provided
        browser is passed explicitly.
      '';
    };
  };

  config.settings.servers = lib.mkIf cfg.enable {
    chrome-devtools = {
      args = [
        "--executable-path"
        cfg.executable
      ];
    };
  };
}
