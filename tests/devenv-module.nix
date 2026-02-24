# Tests for the devenv module mapping logic.
# Uses a mock of devenv's claude.code options so no devenv dependency is needed.
{ pkgs }:
let
  inherit (pkgs) lib;

  mockDevenvModule = {
    options.claude.code = {
      enable = lib.mkEnableOption "claude code";
      mcpServers = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        default = { };
      };
    };
  };

  evalDevenvModule =
    {
      programs ? { },
      settings ? { },
    }:
    lib.evalModules {
      modules = [
        mockDevenvModule
        ../devenv-module.nix
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

  basic = evalDevenvModule {
    programs = {
      filesystem = {
        enable = true;
        args = [ "/test/path" ];
      };
    };
  };

  coercion = evalDevenvModule {
    programs = {
      filesystem = {
        enable = true;
        args = [
          "/path"
          8080
          true
        ];
        env = {
          PORT = 3000;
          DEBUG = true;
          NAME = "test";
        };
      };
    };
  };

  sseMapping = evalDevenvModule {
    settings = {
      servers.my-sse-server = {
        type = "sse";
        url = "http://localhost:3000/sse";
      };
    };
  };

  empty = evalDevenvModule { };
in
{
  # Verify basic stdio server mapping: type null → "stdio", command is a store path, args pass through
  test-devenv-module-basic =
    pkgs.runCommand "test-devenv-module-basic" { nativeBuildInputs = [ pkgs.jq ]; }
      ''
        config='${builtins.toJSON basic.config.claude.code.mcpServers}'

        echo "$config" | jq -e '.filesystem' > /dev/null || (echo "FAIL: missing filesystem server" && exit 1)
        echo "$config" | jq -e '.filesystem.type == "stdio"' > /dev/null || (echo "FAIL: type should be stdio" && exit 1)
        echo "$config" | jq -e '.filesystem.command | startswith("/nix/store/")' > /dev/null || (echo "FAIL: command should be a Nix store path" && exit 1)
        echo "$config" | jq -e '.filesystem.args == ["/test/path"]' > /dev/null || (echo "FAIL: args should contain /test/path" && exit 1)

        echo "All basic devenv module tests passed!"
        touch $out
      '';

  # Verify bool/int args and env values are coerced to strings
  test-devenv-module-coercion =
    pkgs.runCommand "test-devenv-module-coercion" { nativeBuildInputs = [ pkgs.jq ]; }
      ''
        config='${builtins.toJSON coercion.config.claude.code.mcpServers}'

        echo "$config" | jq -e '.filesystem.args | all(type == "string")' > /dev/null || (echo "FAIL: all args should be strings" && exit 1)
        echo "$config" | jq -e '.filesystem.args[1] == "8080"' > /dev/null || (echo "FAIL: int arg should be coerced to string" && exit 1)
        echo "$config" | jq -e '.filesystem.args[2] == "1"' > /dev/null || (echo "FAIL: bool arg should be coerced to string" && exit 1)

        echo "$config" | jq -e '.filesystem.env | to_entries | all(.value | type == "string")' > /dev/null || (echo "FAIL: all env values should be strings" && exit 1)
        echo "$config" | jq -e '.filesystem.env.PORT == "3000"' > /dev/null || (echo "FAIL: int env should be coerced to string" && exit 1)
        echo "$config" | jq -e '.filesystem.env.DEBUG == "1"' > /dev/null || (echo "FAIL: bool env should be coerced to string" && exit 1)
        echo "$config" | jq -e '.filesystem.env.NAME == "test"' > /dev/null || (echo "FAIL: string env should pass through" && exit 1)

        echo "All coercion devenv module tests passed!"
        touch $out
      '';

  # Verify SSE type is mapped to HTTP and URL is preserved
  test-devenv-module-sse-mapping =
    pkgs.runCommand "test-devenv-module-sse-mapping" { nativeBuildInputs = [ pkgs.jq ]; }
      ''
        config='${builtins.toJSON sseMapping.config.claude.code.mcpServers}'

        echo "$config" | jq -e '."my-sse-server".type == "http"' > /dev/null || (echo "FAIL: sse type should be mapped to http" && exit 1)
        echo "$config" | jq -e '."my-sse-server".url == "http://localhost:3000/sse"' > /dev/null || (echo "FAIL: url should be preserved" && exit 1)

        if echo "$config" | jq -e '."my-sse-server".command' > /dev/null 2>&1; then
          echo "FAIL: remote server should not have command"
          exit 1
        fi

        echo "All SSE mapping devenv module tests passed!"
        touch $out
      '';

  # Verify empty config produces no mcpServers
  test-devenv-module-empty = pkgs.runCommand "test-devenv-module-empty" { } ''
    ${
      if empty.config.claude.code.mcpServers == { } then
        "true"
      else
        "echo 'FAIL: mcpServers should be empty' && exit 1"
    }

    echo "All empty devenv module tests passed!"
    touch $out
  '';
}
