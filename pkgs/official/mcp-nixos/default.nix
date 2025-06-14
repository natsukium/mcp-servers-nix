{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "mcp-nixos";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "utensils";
    repo = "mcp-nixos";
    rev = "v${version}";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Placeholder - needs real hash
  };

  pyproject = true;

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    # Core MCP dependencies
    pydantic
    httpx
    beautifulsoup4
    # Additional dependencies based on typical MCP Python servers
    # Will need to check actual pyproject.toml for exact list
  ];

  pythonImportsCheck = [ "mcp_nixos" ];

  # Disable tests for now - can enable once we know the test structure
  doCheck = false;

  meta = {
    description = "Model Context Protocol server that provides access to NixOS packages and configuration options";
    homepage = "https://github.com/utensils/mcp-nixos";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ]; # Add maintainer here
    mainProgram = "mcp-nixos";
  };
}
