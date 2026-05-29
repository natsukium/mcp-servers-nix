{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage (finalAttrs: {
  pname = "esa-mcp-server";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "esaio";
    repo = "esa-mcp-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2IZM85mPKldxuwc8ImXxRCgGNKCBylaSkrGvDjp3BZ8=";
  };

  npmDepsHash = "sha256-TUsBzxs5+32CDoNfgv28JK6Mgnkq4YK8PTmCeHjqL2M=";

  meta = {
    description = "Official MCP server for esa.io";
    homepage = "https://github.com/esaio/esa-mcp-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sei40kr ];
    mainProgram = "esa-mcp-server";
  };
})
