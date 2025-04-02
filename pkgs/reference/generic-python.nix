{
  lib,
  service,
  fetchFromGitHub,
  python3Packages,
  build-system ? [ python3Packages.hatchling ],
  dependencies ? [ ],
  doCheck ? true,
  nativeCheckInputs ? [ python3Packages.pytestCheckHook ],
}:
python3Packages.buildPythonApplication rec {
  pname = "mcp-server-${service}";
  inherit (import ./source.nix { inherit fetchFromGitHub; }) version src;
  pyproject = true;
  sourceRoot = "${src.name}/src/${service}";
  inherit build-system;
  inherit dependencies;

  pythonImportsCheck = [ "mcp_server_${service}" ];

  inherit doCheck;
  inherit nativeCheckInputs;

  meta = {
    description = "Model Context Protocol Servers for ${service}";
    homepage = "https://github.com/modelcontextprotocol/servers";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "mcp-server-${service}";
  };
}
