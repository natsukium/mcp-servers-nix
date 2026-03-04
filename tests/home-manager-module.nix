# Tests for the home-manager module mapping logic.
# Uses a mock of home-manager's programs.mcp options so no home-manager dependency is needed.
{ pkgs }:
let
  inherit (pkgs) lib;

  mockHomeMcpModule = {
    options.programs.mcp = {
      enable = lib.mkEnableOption "mcp";
      servers = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        default = { };
      };
    };
  };

  evalHomeManagerModule =
    {
      programs ? { },
      settings ? { },
    }:
    lib.evalModules {
      modules = [
        mockHomeMcpModule
        ../modules/home-manager.nix
        {
          _module.args = {
            inherit pkgs;
          };
          mcp-servers = {
            inherit programs settings;
          };
        }
      ];
    };

  basic = evalHomeManagerModule {
    programs = {
      filesystem = {
        enable = true;
        args = [ "/test/path" ];
      };
    };
  };

  typeRemoval = evalHomeManagerModule {
    settings = {
      servers.my-sse-server = {
        type = "sse";
        url = "http://localhost:3000/sse";
      };
    };
  };

  empty = evalHomeManagerModule { };

  mcpNotForced = evalHomeManagerModule {
    programs = {
      playwright.enable = true;
    };
  };
in
{
  # Verify basic stdio server mapping: command is a store path, args pass through
  test-home-manager-module-basic =
    pkgs.runCommand "test-home-manager-module-basic" { nativeBuildInputs = [ pkgs.jq ]; }
      ''
        config='${builtins.toJSON basic.config.programs.mcp.servers}'

        echo "$config" | jq -e '.filesystem' > /dev/null || (echo "FAIL: missing filesystem server" && exit 1)
        echo "$config" | jq -e '.filesystem.command | startswith("/nix/store/")' > /dev/null || (echo "FAIL: command should be a Nix store path" && exit 1)
        echo "$config" | jq -e '.filesystem.args == ["/test/path"]' > /dev/null || (echo "FAIL: args should contain /test/path" && exit 1)

        echo "All basic home-manager module tests passed!"
        touch $out
      '';

  # Verify type field is stripped from servers
  test-home-manager-module-type-removal =
    pkgs.runCommand "test-home-manager-module-type-removal" { nativeBuildInputs = [ pkgs.jq ]; }
      ''
        config='${builtins.toJSON typeRemoval.config.programs.mcp.servers}'

        echo "$config" | jq -e '."my-sse-server".url == "http://localhost:3000/sse"' > /dev/null || (echo "FAIL: url should be preserved" && exit 1)

        if echo "$config" | jq -e '."my-sse-server".type' > /dev/null 2>&1; then
          echo "FAIL: type field should be stripped"
          exit 1
        fi

        if echo "$config" | jq -e '."my-sse-server".command' > /dev/null 2>&1; then
          echo "FAIL: remote server should not have command"
          exit 1
        fi

        echo "All type-removal home-manager module tests passed!"
        touch $out
      '';

  # Verify empty config does not set programs.mcp.enable
  test-home-manager-module-empty = pkgs.runCommand "test-home-manager-module-empty" { } ''
    ${
      if !empty.config.programs.mcp.enable then
        "true"
      else
        "echo 'FAIL: programs.mcp.enable should be false when no servers configured' && exit 1"
    }

    echo "All empty home-manager module tests passed!"
    touch $out
  '';

  # Verify programs.mcp.enable is NOT forced when servers exist
  # Users should control programs.mcp.enable themselves
  test-home-manager-module-mcp-not-forced =
    pkgs.runCommand "test-home-manager-module-mcp-not-forced" { }
      ''
        ${
          if !mcpNotForced.config.programs.mcp.enable then
            "true"
          else
            "echo 'FAIL: programs.mcp.enable should not be forced by the module' && exit 1"
        }

        echo "All mcp-not-forced home-manager module tests passed!"
        touch $out
      '';
}
