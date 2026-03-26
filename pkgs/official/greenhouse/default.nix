{
  lib,
  fetchzip,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "greenhouse-mcp";
  version = "0.1.0";

  src = fetchzip {
    url = "https://github.com/alexmeckes/greenhouse-mcp/archive/refs/heads/main.tar.gz";
    hash = "sha256-+Fgct4Z7eHAGUyqv3SZddCsHKTQlT/tEX6joV+NFWqs=";
  };

  format = "pyproject";

  dependencies = with python3Packages; [
    fastmcp
    httpx
    pydantic
    python-dotenv
  ];

  dontCheckPythonImports = true;

  meta = with lib; {
    description = "MCP server for Greenhouse Harvest API";
    homepage = "https://github.com/alexmeckes/greenhouse-mcp";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "greenhouse-mcp";
  };
}