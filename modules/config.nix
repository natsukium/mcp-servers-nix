{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = {
    format = lib.mkOption {
      type = lib.types.enum [
        "json"
        "yaml"
        "toml"
        "toml-inline"
      ];
      default = "json";
      description = ''
        Configuration file format.
      '';
    };
    flavor = lib.mkOption {
      type = lib.types.enum [
        "claude"
        "claude-code"
        "codex"
        "opencode"
        "vscode"
        "vscode-workspace"
        "zed"
      ];
      default = "claude";
      description = ''
        Configuration file type.
        - "claude": Standard Claude Desktop configuration format using "mcpServers" key
        - "claude-code": Claude Code configuration format using "mcpServers" key
        - "codex": Codex CLI configuration format using "mcp_servers" key
        - "opencode": OpenCode configuration format using "mcp" key with command as array
        - "vscode": VSCode global configuration format using "mcp.servers" keys
        - "vscode-workspace": VSCode workspace configuration format with top-level "servers" key,
        - "zed": Zed configuration format with top-level "context_servers" key,
      '';
    };
    fileName = lib.mkOption {
      type = lib.types.str;
      default = "claude_desktop_config.json";
      description = ''
        Configuration file name.
      '';
    };
    configFile = lib.mkOption {
      type = lib.types.path;
      readOnly = true;
      description = ''
        Generated config file derived from the settings.
      '';
    };
    settings = lib.mkOption {
      default = { };
      type = lib.types.submodule {
        freeformType = (pkgs.formats.json { }).type;
      };
    };
  };

  config =
    let
      keys =
        if (config.flavor == "codex") then
          [ "mcp_servers" ]
        else if (config.flavor == "opencode") then
          [ "mcp" ]
        else if (config.flavor == "vscode") then
          [
            "mcp"
            "servers"
          ]
        else if (config.flavor == "vscode-workspace") then
          [ "servers" ]
        else if (config.flavor == "zed") then
          [ "context_servers" ]
        else
          [ "mcpServers" ];

      # Transform server config for OpenCode format
      # OpenCode uses: command (array), environment (not env), type "local"/"remote", enabled
      transformForOpenCode = name: server:
        let
          serverType = server.type or null;
          # Combine command and args into a single command array
          commandArray =
            if server ? command && server.command != null then
              [ server.command ] ++ (server.args or [ ])
            else
              [ ];
          # Map stdio -> local, http/sse -> remote
          opencodeType =
            if serverType == "stdio" || serverType == null then
              "local"
            else
              "remote";
          # For remote servers, we need url instead of command
          isRemote = serverType == "http" || serverType == "sse";
          serverEnv = server.env or { };
          serverHeaders = server.headers or { };
          serverUrl = server.url or null;
        in
        lib.filterAttrs (k: v: v != null && v != { } && v != [ ]) (
          {
            type = opencodeType;
            enabled = true;
          }
          // (if isRemote then {
            url = serverUrl;
            headers = serverHeaders;
          } else {
            command = commandArray;
          })
          // lib.optionalAttrs (serverEnv != { }) {
            environment = serverEnv;
          }
        );

      # Apply transformation if opencode flavor
      serverConfig =
        if config.flavor == "opencode" then
          lib.mapAttrs transformForOpenCode config.settings.servers
        else
          config.settings.servers;
    in
    {
      configFile =
        let
          extraConfig = lib.removeAttrs config.settings [ "servers" ];
          format = pkgs.formats.${config.format} { };
        in
        format.generate config.fileName (
          lib.recursiveUpdate (lib.setAttrByPath keys serverConfig) extraConfig
        );
    };
}
