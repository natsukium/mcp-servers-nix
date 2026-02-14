{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.playwright-mcp;
in
{

  options.services.playwright-mcp = {
    enable = lib.mkEnableOption "playwright-mcp";

    package = lib.mkPackageOption pkgs "playwright-mcp" { };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
      description = ''
        Host to bind server to. Default is localhost. Use 0.0.0.0 to bind to all interfaces.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8931;
      description = "Port to listen on for SSE transport";
    };

    extraArgs = lib.mkOption {
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

  };

  config = lib.mkIf cfg.enable {
    systemd.services.playwright-mcp = {
      description = "Playwright MCP Server Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ];
      script = ''
        exec ${lib.getExe cfg.package} --port ${cfg.port} --host ${cfg.host} ${cfg.extraArgs}
      '';
      serviceConfig = {
        User = "playwright-mcp";
        Restart = "on-failure";
        RuntimeDirectory = "playwright-mcp";
        RuntimeDirectoryMode = "0755";
        # Hardening
        AmbientCapabilities = lib.mkIf (cfg.settings.server.http_port < 1024) [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet =
          if (cfg.settings.server.http_port < 1024) then [ "CAP_NET_BIND_SERVICE" ] else [ "" ];
        DeviceAllow = [ "" ];
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "full";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        UMask = "0027";
      };
    };
  };
}
