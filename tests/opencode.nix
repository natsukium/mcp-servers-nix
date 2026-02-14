# Test for OpenCode flavor configuration
# OpenCode uses a different format: "mcp" key, array commands, "type": "local"/"remote"
{ pkgs }:
let
  inherit (import ../lib) mkConfig;
  # Create a test configuration for OpenCode
  testConfig = mkConfig pkgs {
    flavor = "opencode";
    fileName = "opencode.json";

    programs = {
      filesystem = {
        enable = true;
        args = [ "/test/path" ];
      };
      fetch.enable = true;
    };
  };
in
{
  test-opencode-format =
    pkgs.runCommand "test-opencode-format"
      {
        nativeBuildInputs = with pkgs; [ jq ];
      }
      ''
        # Verify the config has the correct OpenCode structure
        config=$(cat ${testConfig})
        
        # Check that "mcp" key exists (not "mcpServers")
        echo "$config" | jq -e '.mcp' > /dev/null || (echo "FAIL: missing 'mcp' key" && exit 1)
        
        # Check that mcpServers does NOT exist
        if echo "$config" | jq -e '.mcpServers' > /dev/null 2>&1; then
          echo "FAIL: should not have 'mcpServers' key"
          exit 1
        fi
        
        # Check filesystem server has correct OpenCode format
        echo "$config" | jq -e '.mcp.filesystem.command | type == "array"' > /dev/null || (echo "FAIL: command should be array" && exit 1)
        echo "$config" | jq -e '.mcp.filesystem.type == "local"' > /dev/null || (echo "FAIL: type should be 'local'" && exit 1)
        echo "$config" | jq -e '.mcp.filesystem.enabled == true' > /dev/null || (echo "FAIL: enabled should be true" && exit 1)
        
        # Check fetch server exists
        echo "$config" | jq -e '.mcp.fetch' > /dev/null || (echo "FAIL: missing fetch server" && exit 1)
        
        # Check that args are included in command array for filesystem
        echo "$config" | jq -e '.mcp.filesystem.command | length > 1' > /dev/null || (echo "FAIL: args should be in command array" && exit 1)
        echo "$config" | jq -e '.mcp.filesystem.command[-1] == "/test/path"' > /dev/null || (echo "FAIL: args not correctly appended" && exit 1)
        
        echo "All OpenCode format tests passed!"
        touch $out
      '';
}
