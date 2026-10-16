{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage (finalAttrs: {
  pname = "esa-mcp-server";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "esaio";
    repo = "esa-mcp-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HvthBtaoXitExShcb2x7vljAPOLy6fLR5Zq5NCEUvzU=";
  };

  npmDepsHash = "sha256-/85Gz4/t8s4JQ5Hx5Ayv3cBdsklSUA6vde7MV2xW67M=";

  meta = {
    description = "Official MCP server for esa.io";
    homepage = "https://github.com/esaio/esa-mcp-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sei40kr ];
    mainProgram = "esa-mcp-server";
  };
})
