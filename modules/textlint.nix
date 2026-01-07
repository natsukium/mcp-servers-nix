{
  config,
  pkgs,
  lib,
  mkServerModule,
  ...
}:
let
  cfg = config.programs.textlint;

  finalPackage =
    if cfg.extensions == [ ] then
      pkgs.textlint
    else
      pkgs.textlint.withPackages cfg.extensions;
in
{
  imports = [
    (mkServerModule {
      name = "textlint";
      packageName = "textlint";
    })
  ];

  options.programs.textlint = {
    extensions = lib.mkOption {
      type = with lib.types; listOf package;
      default = [ ];
      example = lib.literalExpression ''
        [
          pkgs.textlint-rule-alex
          pkgs.textlint-plugin-org
          pkgs.textlint-rule-preset-ja-technical-writing
        ]
      '';
      description = ''
        List of textlint extension packages (rules, plugins, presets, filter-rules, configs).
        These packages will be available via NODE_PATH.
      '';
    };

    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = lib.literalExpression "./.textlintrc.json";
      description = ''
        Path to .textlintrc configuration file.
        This file specifies which rules to enable and their settings.
        Takes precedence over the settings option.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      example = lib.literalExpression ''
        {
          rules = {
            alex = true;
            terminology = {
              defaultTerms = true;
            };
          };
        }
      '';
      description = ''
        Textlint configuration expressed as Nix attributes.
        Will be converted to JSON and used as the configuration file.
        Ignored if configFile is set.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.textlint.package = lib.mkDefault finalPackage;

    settings.servers.textlint = {
      args =
        [ "--mcp" ]
        ++ lib.optionals (cfg.configFile != null) [
          "--config"
          (toString cfg.configFile)
        ];
    };
  };
}
