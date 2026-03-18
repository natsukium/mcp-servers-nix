{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication {
  pname = "fibery-mcp-server";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "Fibery-inc";
    repo = "fibery-mcp-server";
    rev = "8fef67be956808d183ce5f5f6e7c388794d08a74";
    hash = "sha256-cnYW5RMOMvSS0829WmHhW55PxFq+3khz53kWU8qRsaU=";
  };

  pyproject = true;

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    click
    httpx
    mcp
    pydantic
    python-dotenv
  ];

  meta = {
    description = "Fibery MCP Server - Integration between Fibery and LLM providers";
    homepage = "https://github.com/Fibery-inc/fibery-mcp-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "fibery-mcp-server";
  };
}
