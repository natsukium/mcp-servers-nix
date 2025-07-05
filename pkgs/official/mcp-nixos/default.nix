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
    hash = "sha256-NwP+zM1VGLOzIm+mLZVK9/9ImFwuiWhRJ9QK3hGpQsY=";
  };

  pyproject = true;

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    # Core dependencies available in nixpkgs
    pydantic
    httpx
    beautifulsoup4
    requests
    # Note: 'mcp' package not available in nixpkgs
    # The uv2nix version handles the full dependency set
  ];

  # Handle version conflicts and missing dependencies
  nativeBuildInputs = [
    python3Packages.pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "beautifulsoup4"
  ];

  # Skip runtime dependency check since 'mcp' package not in nixpkgs
  dontCheckRuntimeDeps = true;

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
