{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage (finalAttrs: {
  pname = "esa-mcp-server";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "esaio";
    repo = "esa-mcp-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2DgEv6SuJSrVXDocFpJVIAG19dhr4vhPakJW3ipOA5A=";
  };

  npmDepsHash = "sha256-VW1MKl5Oe4fKOMyWplLlBVlSMxeeOWN1HUYFux+sx0k=";

  meta = {
    description = "Official MCP server for esa.io";
    homepage = "https://github.com/esaio/esa-mcp-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sei40kr ];
    mainProgram = "esa-mcp-server";
  };
})
