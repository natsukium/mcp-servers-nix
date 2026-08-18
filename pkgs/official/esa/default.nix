{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage (finalAttrs: {
  pname = "esa-mcp-server";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "esaio";
    repo = "esa-mcp-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2J5LdiZ5jLuUDI37lVFVL4q25iBo3aHaP2vNcakyLPg=";
  };

  npmDepsHash = "sha256-dyEiBnGznXJO3Ek1tJtrHdDEKJThUl0Rtn5f8nR1+bs=";

  meta = {
    description = "Official MCP server for esa.io";
    homepage = "https://github.com/esaio/esa-mcp-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sei40kr ];
    mainProgram = "esa-mcp-server";
  };
})
