{
  lib,
  service,
  fetchFromGitHub,
  python314Packages,
  build-system ? [ python314Packages.hatchling ],
  dependencies ? [ ],
  pythonRelaxDeps ? [ ],
  doCheck ? true,
  nativeCheckInputs ? [ python314Packages.pytestCheckHook ],
}:
python314Packages.buildPythonApplication rec {
  pname = "mcp-server-${service}";
  inherit (import ./source.nix { inherit fetchFromGitHub; }) version src;
  pyproject = true;
  sourceRoot = "${src.name}/src/${service}";
  inherit
    build-system
    dependencies
    pythonRelaxDeps
    doCheck
    nativeCheckInputs
    ;

  pythonImportsCheck = [ "mcp_server_${service}" ];

  meta = {
    description = "Model Context Protocol Servers for ${service}";
    homepage = "https://github.com/modelcontextprotocol/servers";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "mcp-server-${service}";
  };
}
