# Tests for textlint MCP server module
{ pkgs }:
let
  mcp-servers = import ../../. { inherit pkgs; };
in
{
  # Minimal: bare textlint without extensions or configFile
  test-textlint-bare =
    let
      evaluated-module = mcp-servers.lib.evalModule pkgs {
        flavor = "claude";
        format = "json";
        programs.textlint.enable = true;
      };
      serverConfig = evaluated-module.config.settings.servers.textlint;
    in
    pkgs.runCommand "test-textlint-bare" { nativeBuildInputs = with pkgs; [ jq ]; } ''
      touch $out
      # Verify bare textlint is used (not textlint-with-packages)
      echo "${serverConfig.command}" | grep -qv "textlint-with-packages"
      echo "${serverConfig.command}" | grep -q "/bin/textlint$"
      # Verify --mcp arg is present, --config is absent
      echo '${builtins.toJSON serverConfig.args}' | jq -e '. == ["--mcp"]'
    '';

  # configFile only: bare textlint with --config arg
  test-textlint-config-only =
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
    pkgs.runCommand "test-textlint-config-only" { nativeBuildInputs = with pkgs; [ jq ]; } ''
      touch $out
      # Verify bare textlint is used (no extensions)
      echo "${serverConfig.command}" | grep -qv "textlint-with-packages"
      echo "${serverConfig.command}" | grep -q "/bin/textlint$"
      # Verify --mcp and --config args are present
      echo '${builtins.toJSON serverConfig.args}' | jq -e 'contains(["--mcp", "--config"])'
    '';

  # Extensions only: textlint-with-packages without configFile
  test-textlint-extensions-only =
    let
      evaluated-module = mcp-servers.lib.evalModule pkgs {
        flavor = "claude";
        format = "json";
        programs.textlint = {
          enable = true;
          rules = [ pkgs.textlint-rule-alex ];
        };
      };
      serverConfig = evaluated-module.config.settings.servers.textlint;
    in
    pkgs.runCommand "test-textlint-extensions-only" { nativeBuildInputs = with pkgs; [ jq ]; } ''
      touch $out
      # Verify textlint-with-packages is used
      echo "${serverConfig.command}" | grep -q "textlint-with-packages"
      # Verify --mcp arg only (no --config)
      echo '${builtins.toJSON serverConfig.args}' | jq -e '. == ["--mcp"]'
    '';

  # Maximum: all available extension types + configFile
  # Note: filterRules and configs have no packages in nixpkgs, so not tested here
  test-textlint-all-options =
    let
      evaluated-module = mcp-servers.lib.evalModule pkgs {
        flavor = "claude";
        format = "json";
        programs.textlint = {
          enable = true;
          rules = [ pkgs.textlint-rule-alex pkgs.textlint-rule-terminology ];
          plugins = [ pkgs.textlint-plugin-org pkgs.textlint-plugin-latex2e ];
          presets = [ pkgs.textlint-rule-preset-ja-technical-writing ];
          configFile = ./.textlintrc.json;
        };
      };
      serverConfig = evaluated-module.config.settings.servers.textlint;
    in
    pkgs.runCommand "test-textlint-all-options" { nativeBuildInputs = with pkgs; [ jq ]; } ''
      touch $out
      # Verify textlint-with-packages is used
      echo "${serverConfig.command}" | grep -q "textlint-with-packages"
      # Verify --mcp and --config args are present
      echo '${builtins.toJSON serverConfig.args}' | jq -e 'contains(["--mcp", "--config"])'
    '';
}
