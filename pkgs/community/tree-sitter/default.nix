{
  lib,
  python3,
  fetchpatch,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mcp-server-tree-sitter";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wrale";
    repo = "mcp-server-tree-sitter";
    rev = "v${version}";
    hash = "sha256-YRnTEzs8OAY0ADkTT3b20owVDnEJ5om4VoDFDRbjXVs=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/joubertdj/mcp-server-tree-sitter/commit/24334d3322716cd12c65fe289587c3c341d6c030.patch";
      hash = "sha256-9VwTTIZFcU+nCBuJH2LOEhJBzm5B4m6KUgXpBP1gdYs=";
    })
  ];

  build-system = [
    python3.pkgs.hatchling
  ];

  dependencies = with python3.pkgs; [
    mcp
    pydantic
    pyyaml
    tree-sitter
    tree-sitter-language-pack
    types-pyyaml
  ];

  optional-dependencies = with python3.pkgs; {
    dev = [
      mypy
      pytest
      pytest-cov
      ruff
    ];
  };

  pythonImportsCheck = [
    "mcp_server_tree_sitter"
  ];

  meta = {
    description = "MCP Server for Tree-sitter";
    homepage = "https://github.com/wrale/mcp-server-tree-sitter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "mcp-server-tree-sitter";
  };
}
