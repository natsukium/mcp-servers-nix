{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "mcp-server-qdrant";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "mcp-server-qdrant";
    rev = "v${version}";
    hash = "sha256-Zp66m1DYY0H/0EdOXc6PRwte1Kc4asRuEmbYENm0GRM=";
  };

  build-system = [python3Packages.hatchling];

  pythonRelaxDeps = ["fastmcp"];

  dependencies = with python3Packages; [
    mcp
    pydantic
    tzdata
    # NOTE: fastembed is disabled on aarch64-linux due to ONNX Runtime compatibility issues
    # Override at your own risk - it may build but fail at runtime
    fastembed
    qdrant-client
    fastmcp
  ];

  doCheck = false;

  pythonImportsCheck = ["mcp_server_qdrant"];

  meta = {
    description = "Model Context Protocol Server for Qdrant";
    homepage = "https://github.com/qdrant/mcp-server-qdrant";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [vaporif];
    mainProgram = "mcp-server-qdrant";
    # Inherit platform restrictions from fastembed due to ONNX Runtime issues
    inherit (python3Packages.fastembed.meta) platforms badPlatforms;
  };
}
