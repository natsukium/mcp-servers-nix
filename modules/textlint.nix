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
    if cfg.extensions == [ ] then pkgs.textlint else pkgs.textlint.withPackages cfg.extensions;

  configFile =
    if cfg.configFile != null then
      cfg.configFile
    else if cfg.settings != { } then
      pkgs.writeText ".textlintrc.json" (builtins.toJSON cfg.settings)
    else
      null;
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
    assertions = [
      {
        assertion = cfg.configFile != null || cfg.settings != { };
        message = "programs.textlint requires either configFile or settings to be set.";
      }
    ];

    programs.textlint.package = lib.mkDefault finalPackage;

    settings.servers.textlint = {
      args = [
        "--mcp"
        "--config"
        (toString configFile)
      ];
    };
  };
}
