{ pkgs }:
let
  inherit (import ../lib) mkConfig;
  # Create a test configuration for codex with inline TOML
  testConfig = mkConfig pkgs {
    flavor = "codex";
    format = "toml-inline";
    fileName = ".mcp.toml";

    programs = {
      filesystem = {
        enable = true;
        args = [ "/test/path" ];
        env = {
          TEST_VAR = "test_value";
        };
      };
    };
  };
in
{
  test-codex =
    pkgs.runCommand "test-codex"
      {
        nativeBuildInputs = with pkgs; [
          codex
        ];
      }
      ''
        export CODEX_HOME=$(mktemp -d)
        codex -c "$(cat ${testConfig})" mcp list | grep -e filesystem > $out
      '';
}
