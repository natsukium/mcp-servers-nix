{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "markitdown-mcp";
  version = "0.0.1a4";
  pyproject = true;

  src = fetchPypi {
    pname = "markitdown_mcp";
    inherit version;
    hash = "sha256-MJyU3IgzEeaQnYSTgqbHvEAt+yaS2rRIwTbGhkxr9J4=";
  };

  build-system = [
    python3.pkgs.hatchling
  ];

  nativeBuildInputs = [
    python3.pkgs.pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "mcp"
  ];

  dependencies = with python3.pkgs; [
    markitdown
    mcp
  ];

  pythonImportsCheck = [
    "markitdown_mcp"
  ];

  meta = {
    description = "An MCP server for the \"markitdown\" library";
    homepage = "https://pypi.org/project/markitdown-mcp/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ malik ];
    mainProgram = "markitdown-mcp";
  };
}
