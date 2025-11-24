{
  lib,
  self,
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

        # Available flavors
        flavors = [
          "claude"
          "codex"
          "vscode"
          "vscode-workspace"
          "zed"
        ];

        # Default format for each flavor
        # Each MCP client application expects a specific configuration format
        flavorFormatMap = {
          claude = "json"; # Claude Desktop reads JSON only
          codex = "toml-inline"; # Codex CLI expects TOML with inline tables
          vscode = "json"; # VSCode settings are JSON
          vscode-workspace = "json"; # VSCode workspace files are JSON
          zed = "json"; # Zed settings are JSON
        };

        # Create a base module config for a specific flavor
        mkFlavorConfig =
          flavor: overrideConfig:
          let
            # Merge base programs and settings with flavor-specific overrides
            baseConfig = {
              programs = cfg.programs;
              settings = cfg.settings;
            };
            mergedConfig = lib.recursiveUpdate baseConfig overrideConfig;
            # Auto-determine format based on flavor, allow override
            flavorFormat = mergedConfig.format or flavorFormatMap.${flavor};
          in
          {
            inherit flavor;
            format = flavorFormat;
          }
          // mergedConfig;

        # Generate config file for an enabled flavor
        mkFlavorOutput =
          flavor:
          let
            overrideConfig = cfg.overrides.${flavor} or { };
            flavorConfig = mkFlavorConfig flavor overrideConfig;
          in
          mcp-lib.evalModule pkgs flavorConfig;

        # Collect all enabled flavors
        enabledFlavors = lib.filter (flavor: cfg.flavors.${flavor}.enable) flavors;

        # Collect all enabled MCP server packages
        enabledPackages =
          let
            # Extract packages from evaluated configs
            extractPackages = evaluatedConfig:
              let
                # Get enabled programs from the evaluated config
                programs = lib.filterAttrs (
                  name: _: evaluatedConfig.config.programs.${name}.enable or false
                ) evaluatedConfig.config.programs;
              in
              lib.mapAttrsToList (_: v: v.package) programs;

            # If no flavors are enabled, evaluate base config with default flavor
            packagesFromFlavors =
              if enabledFlavors == [ ] then
                [ ]
              else
                lib.unique (lib.flatten (lib.map (flavor: extractPackages (mkFlavorOutput flavor)) enabledFlavors));
          in
          packagesFromFlavors;

        # Create shellHook for all enabled flavors
        shellHook = lib.concatMapStringsSep "\n" (
          flavor:
          let
            evaluated = mkFlavorOutput flavor;
            configFile = evaluated.config.configFile;
            fileName =
              {
                claude = ".mcp.json";
                codex = ".codex/mcp.json";
                vscode = ".vscode/settings.json";
                vscode-workspace = ".vscode/mcp.json";
                zed = ".config/zed/settings.json";
              }
              .${flavor}
              or ".mcp-${flavor}.json";
            targetDir = builtins.dirOf fileName;
          in
          ''
            ${lib.optionalString (targetDir != ".") "mkdir -p ${targetDir}"}
            ln -sf ${configFile} ${fileName}
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
                Can be overridden per-flavor using `overrides.<flavor>.programs`.
              '';
              example = lib.literalExpression ''
                {
                  playwright.enable = true;
                  github = {
                    enable = true;
                    env.GITHUB_PERSONAL_ACCESS_TOKEN = "token";
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

                Can be overridden per-flavor using `overrides.<flavor>.settings`.
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

            flavors = lib.genAttrs flavors (
              flavor:
              mkOption {
                type = types.submodule {
                  options = {
                    enable = mkEnableOption "MCP server configuration for ${flavor}";
                  };
                };
                default = { };
                description = ''
                  Enable MCP server configuration generation for ${flavor}.
                '';
              }
            );

            overrides = lib.genAttrs flavors (
              flavor:
              mkOption {
                type = types.attrsOf types.anything;
                default = { };
                description = ''
                  Override configuration for ${flavor} flavor.

                  - `programs`: Override program settings (merged with base programs)
                  - `settings`: Override additional settings (merged with base settings)
                  - `format`: Override output format (auto-determined by default: ${flavorFormatMap.${flavor}})

                  These settings are recursively merged with the base configuration.

                  Note: Format is automatically determined based on flavor requirements.
                  Most users should not need to override the format.
                '';
                example = lib.literalExpression ''
                  {
                    programs.playwright = {
                      env.CUSTOM_VAR = "value";
                    };
                    settings.servers = {
                      custom-server = {
                        command = "npx";
                        args = [ "-y" "custom-mcp" ];
                      };
                    };
                    settings.inputs = [  # VSCode-specific
                      {
                        type = "promptString";
                        id = "token";
                        description = "API Token";
                      }
                    ];
                  }
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
            configs = lib.genAttrs enabledFlavors (
              flavor: (mkFlavorOutput flavor).config.configFile
            );

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
