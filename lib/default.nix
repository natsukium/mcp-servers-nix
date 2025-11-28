let
  mkServerModule =
    {
      name,
      packageName ? "mcp-server-${name}",
    }:
    {
      config,
      pkgs,
      lib,
      servers,
      ...
    }:
    let
      cfg = config.programs.${name};
    in
    {
      imports = [
        (lib.mkRemovedOptionModule [ "programs" name "wrapPackageWithEnvFile" ] ''
          The option 'wrapPackageWithEnvFile' has been removed as it is no longer needed.
        '')
      ];

      options.programs.${name} = {
        enable = lib.mkEnableOption name;
        package = lib.mkPackageOption servers packageName { };
        type = lib.mkOption {
          type = lib.types.nullOr (
            lib.types.enum [
              "sse"
              "stdio"
            ]
          );
          default = null;
          description = ''
            Server connection type.
          '';
        };
        args = lib.mkOption {
          type =
            with lib.types;
            listOf (oneOf [
              bool
              int
              str
            ]);
          default = [ ];
          description = ''
            Array of arguments passed to the command.
          '';
        };
        env = lib.mkOption {
          type =
            with lib.types;
            attrsOf (oneOf [
              bool
              int
              str
            ]);
          default = { };
          description = ''
            Environment variables for the server.
            For security reasons, do not hardcode your credentials in the env.
            All files in /nix/store can be read by anyone with access to the store.
            Always use envFile instead.
          '';
        };
        url = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            URL of the server (for "sse").
          '';
        };
        envFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = ''
            Path to an .env from which to load additional environment variables.
            When flavor is set to 'vscode', the environment file is passed directly as a parameter instead of wrapping by default.
          '';
        };
        passwordCommand = lib.mkOption {
          type = with lib.types; nullOr (either str (attrsOf (listOf str)));
          default = null;
          description = ''
            Command to execute to retrieve secrets. Can be specified in two ways:

            1. As a string: The command should output in the format "KEY=VALUE" which will be exported as environment variables.
               Example: "pass mcp-server"

            2. As an attribute set: Keys are environment variable names and values are command lists that output the value.
               Example: { GITHUB_PERSONAL_ACCESS_TOKEN = [ "gh" "auth" "token" ]; }

            This is useful for integrating with password managers or similar tools.
            passwordCommand is always handled via the wrapper regardless of flavor.
          '';
          example = lib.literalExpression ''
            {
              GITHUB_PERSONAL_ACCESS_TOKEN = [
                "gh"
                "auth"
                "token"
              ];
            }
          '';
        };
      };

      config.settings.servers =
        let
          exportEnvFile = (cfg.envFile != null) && (config.flavor != "vscode");
          exportPasswordCommand = cfg.passwordCommand != null;
          doWrap = exportEnvFile || exportPasswordCommand;
          mkExportCommand = source: ''
            export $(${source} | ${lib.getExe pkgs.gnugrep} -v '^#' | ${lib.getExe' pkgs.findutils "xargs"} -d '\n')
          '';
          wrapped-package = pkgs.writeScriptBin packageName ''
            #!${pkgs.runtimeShell}
            ${lib.optionalString exportEnvFile (
              mkExportCommand ("${lib.getExe' pkgs.coreutils "cat"} ${lib.escapeShellArg cfg.envFile}")
            )}
            ${lib.optionalString exportPasswordCommand (
              if (lib.isString cfg.passwordCommand) then
                mkExportCommand cfg.passwordCommand
              else
                lib.concatMapAttrsStringSep "\n" (
                  name: value: "export ${name}=$(${toString value})"
                ) cfg.passwordCommand
            )}
            ${lib.getExe cfg.package} "$@"
          '';
          package = if doWrap then wrapped-package else cfg.package;
        in
        lib.mkIf cfg.enable {
          ${name} = lib.filterAttrs (k: v: v != null) (
            {
              command = lib.mkDefault "${lib.getExe package}";
              inherit (cfg)
                args
                env
                type
                url
                ;
            }
            // lib.optionalAttrs (config.flavor == "vscode") { inherit (cfg) envFile; }
          );
        };
    };
  evalModule =
    nixpkgs: config:
    nixpkgs.lib.evalModules {
      modules = [
        {
          _module.args = {
            pkgs = nixpkgs.extend (
              final: prev: {
                formats =
                  prev.formats
                  // (import ../lib/formats.nix {
                    pkgs = final;
                    lib = final.lib;
                  });
              }
            );
          };
        }
        {
          imports = (
            builtins.map (module: ../modules + "/${module}") (builtins.filter (name: builtins.match ".*\\.nix" name != null) (builtins.attrNames (builtins.readDir ../modules)))
          );
        }
        config
      ];
      specialArgs = {
        servers = nixpkgs.extend (import ../overlays);
        inherit mkServerModule;
      };
    };
in
{
  inherit evalModule;
  mkConfig = pkgs: config: (evalModule pkgs config).config.configFile;
}
