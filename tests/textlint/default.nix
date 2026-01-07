# Tests for textlint MCP server module
{ pkgs }:
let
  mcp-servers = import ../../. { inherit pkgs; };
in
{
  # Test with configFile: textlint with external config file
  test-textlint-with-configFile =
    let
      evaluated-module = mcp-servers.lib.evalModule pkgs {
        flavor = "claude";
        format = "json";
        programs.textlint = {
          enable = true;
          configFile = ./.textlintrc.json;
        };
      };
      serverConfig = evaluated-module.config.settings.servers.textlint;
    in
    pkgs.runCommand "test-textlint-with-configFile" { nativeBuildInputs = with pkgs; [ jq ]; } ''
      touch $out
      # Verify bare textlint is used (no extensions)
      echo "${serverConfig.command}" | grep -qv "textlint-with-packages"
      echo "${serverConfig.command}" | grep -q "/bin/textlint$"
      # Verify --mcp and --config args are present
      echo '${builtins.toJSON serverConfig.args}' | jq -e 'contains(["--mcp", "--config"])'
    '';

  # Test with settings: textlint with Nix-native configuration
  test-textlint-with-settings =
    let
      evaluated-module = mcp-servers.lib.evalModule pkgs {
        flavor = "claude";
        format = "json";
        programs.textlint = {
          enable = true;
          settings = {
            rules = {
              alex = true;
            };
          };
        };
      };
      serverConfig = evaluated-module.config.settings.servers.textlint;
    in
    pkgs.runCommand "test-textlint-with-settings" { nativeBuildInputs = with pkgs; [ jq ]; } ''
      touch $out
      # Verify bare textlint is used (no extensions)
      echo "${serverConfig.command}" | grep -qv "textlint-with-packages"
      echo "${serverConfig.command}" | grep -q "/bin/textlint$"
      # Verify --mcp and --config args are present
      echo '${builtins.toJSON serverConfig.args}' | jq -e 'contains(["--mcp", "--config"])'
    '';

  # Test with extensions and configFile
  test-textlint-with-extensions =
    let
      evaluated-module = mcp-servers.lib.evalModule pkgs {
        flavor = "claude";
        format = "json";
        programs.textlint = {
          enable = true;
          extensions = [
            pkgs.textlint-rule-alex
            pkgs.textlint-plugin-org
            pkgs.textlint-rule-preset-ja-technical-writing
          ];
          configFile = ./.textlintrc.json;
        };
      };
      serverConfig = evaluated-module.config.settings.servers.textlint;
    in
    pkgs.runCommand "test-textlint-with-extensions" { nativeBuildInputs = with pkgs; [ jq ]; } ''
      touch $out
      # Verify textlint-with-packages is used
      echo "${serverConfig.command}" | grep -q "textlint-with-packages"
      # Verify --mcp and --config args are present
      echo '${builtins.toJSON serverConfig.args}' | jq -e 'contains(["--mcp", "--config"])'
    '';
}
