{
  lib,
  flake-parts-lib,
  ...
}:
let
  inherit (lib)
    mkOption
    mkEnableOption
    types
    ;
in
{
  options = {
    perSystem = flake-parts-lib.mkPerSystemOption (
      {
        config,
        pkgs,
        ...
      }:
      let
        cfg = config.mcp-servers;
        mcp-lib = import ./lib;

        flavorNames = [
          "claude-code"
          "vscode-workspace"
        ];

        flavorFormatMap = {
          claude-code = "json";
          vscode-workspace = "json";
        };

        mkFlavorConfig =
          flavor:
          let
            flavorCfg = cfg.flavors.${flavor};
            baseConfig = {
              inherit (cfg) programs settings;
            };
            flavorOverrides = {
              inherit (flavorCfg) programs settings;
            };
            mergedConfig = lib.recursiveUpdate baseConfig flavorOverrides;
            flavorFormat = flavorCfg.format or flavorFormatMap.${flavor};
          in
          {
            inherit flavor;
            format = flavorFormat;
          }
          // mergedConfig;

        mkFlavorOutput =
          flavor:
          let
            flavorConfig = mkFlavorConfig flavor;
          in
          mcp-lib.evalModule pkgs flavorConfig;

        enabledFlavors = lib.filter (flavor: cfg.flavors.${flavor}.enable) flavorNames;

        enabledPackages =
          let
            extractPackages =
              evaluatedConfig:
              let
                programs = lib.filterAttrs (
                  name: _: evaluatedConfig.config.programs.${name}.enable or false
                ) evaluatedConfig.config.programs;
              in
              lib.mapAttrsToList (_: v: v.package) programs;

            packagesFromFlavors =
              if enabledFlavors == [ ] then
                [ ]
              else
                lib.unique (lib.flatten (lib.map (flavor: extractPackages (mkFlavorOutput flavor)) enabledFlavors));
          in
          packagesFromFlavors;

        shellHook = lib.concatMapStringsSep "\n" (
          flavor:
          let
            evaluated = mkFlavorOutput flavor;
            configFile = evaluated.config.configFile;
            fileName =
              {
                claude-code = ".mcp.json";
                vscode-workspace = ".vscode/mcp.json";
              }
              .${flavor};
            targetDir = builtins.dirOf fileName;
          in
          ''
            ${lib.optionalString (targetDir != ".") "mkdir -p ${targetDir}"}
            ${
              if cfg.addGcRoot then
                "nix-store --add-root ${fileName} --indirect --realise ${configFile}"
              else
                "ln -sf ${configFile} ${fileName}"
            }
          ''
        ) enabledFlavors;
      in
      {
        options = {
          mcp-servers = {
            programs = mkOption {
              type = types.attrsOf types.anything;
              default = { };
              description = ''
                Base MCP server configuration applied to all enabled flavors.
                Can be overridden per-flavor using `flavors.<flavor>.programs`.
              '';
              example = lib.literalExpression ''
                {
                  playwright.enable = true;
                  github = {
                    enable = true;
                  };
                }
              '';
            };

            settings = mkOption {
              type = types.submodule {
                freeformType = (pkgs.formats.json { }).type;
              };
              default = { };
              description = ''
                Additional freeform configuration applied to all enabled flavors.

                - `settings.servers`: Add custom MCP servers or augment built-in servers
                - `settings.<other>`: Add top-level configuration fields

                Can be overridden per-flavor using `flavors.<flavor>.settings`.
              '';
              example = lib.literalExpression ''
                {
                  servers = {
                    obsidian = {
                      command = "''${pkgs.nodejs}/bin/npx";
                      args = [ "-y" "mcp-obsidian" "/path/to/vault" ];
                    };
                  };
                }
              '';
            };

            addGcRoot = mkOption {
              type = types.bool;
              default = true;
              description = ''
                Whether to add the generated MCP config files to the garbage collector roots.
                This prevents Nix from garbage-collecting the configuration files and
                MCP server packages referenced in them.
              '';
            };

            flavors = lib.genAttrs flavorNames (
              flavor:
              mkOption {
                type = types.submodule {
                  options = {
                    enable = mkEnableOption "MCP server configuration for ${flavor}";

                    programs = mkOption {
                      type = types.attrsOf types.anything;
                      default = { };
                      description = ''
                        Override MCP server program configuration for ${flavor}.
                        These settings are recursively merged with the base programs.
                      '';
                      example = lib.literalExpression ''
                        {
                          playwright.env.CUSTOM_VAR = "value";
                          filesystem.args = [ "/custom/path" ];
                        }
                      '';
                    };

                    settings = mkOption {
                      type = types.submodule {
                        freeformType = (pkgs.formats.json { }).type;
                      };
                      default = { };
                      description = ''
                        Override additional settings for ${flavor}.
                        These settings are recursively merged with the base settings.
                      '';
                      example = lib.literalExpression ''
                        {
                          servers.custom-server = {
                            command = "npx";
                            args = [ "-y" "custom-mcp" ];
                          };
                          inputs = [  # VSCode-specific
                            {
                              type = "promptString";
                              id = "token";
                              description = "API Token";
                            }
                          ];
                        }
                      '';
                    };
                  };
                };
                default = { };
                description = ''
                  MCP server configuration for ${flavor}.
                '';
              }
            );

            configs = mkOption {
              type = types.attrsOf types.package;
              readOnly = true;
              description = ''
                Generated configuration files for each enabled flavor.
              '';
            };

            packages = mkOption {
              type = types.listOf types.package;
              readOnly = true;
              description = ''
                List of all enabled MCP server packages.
              '';
            };

            shellHook = mkOption {
              type = types.str;
              readOnly = true;
              description = ''
                Shell hook that creates symlinks for all enabled flavor configurations.
              '';
            };

            devShell = mkOption {
              type = types.package;
              readOnly = true;
              description = ''
                Development shell with MCP server packages and configuration setup.
              '';
            };
          };
        };

        config = {
          mcp-servers = {
            configs = lib.genAttrs enabledFlavors (flavor: (mkFlavorOutput flavor).config.configFile);

            packages = enabledPackages;

            inherit shellHook;

            devShell = pkgs.mkShell {
              nativeBuildInputs = cfg.packages;
              shellHook = cfg.shellHook;
            };
          };
        };
      }
    );
  };
}
