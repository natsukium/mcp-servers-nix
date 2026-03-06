{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "mcp-logseq";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ergut";
    repo = "mcp-logseq";
    rev = "a2517a0191170da5b523269b0bf694601fcca324";
    hash = "sha256-zFpIgbkTeqg8pC342PBsD+XlFWJrlF451TU/7SeNxQ4=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    mcp
    python-dotenv
    requests
    pyyaml
  ];

  pythonImportsCheck = [ "mcp_logseq" ];

  meta = {
    description = "MCP server to interact with LogSeq via its Local HTTP API";
    homepage = "https://github.com/ergut/mcp-logseq";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ]; # Add yourself if you want
    mainProgram = "mcp-logseq";
  };
}
