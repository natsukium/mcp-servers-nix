{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage (finalAttrs: {
  pname = "esa-mcp-server";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "esaio";
    repo = "esa-mcp-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RiInTTxqPayQjb4nEz6HQ1J24j4eb4/v0nnavLall5A=";
  };

  npmDepsHash = "sha256-el5JrIGxoovXY2hDCiRYB2Z5yT067cElBK8J2eT/tuA=";

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Official MCP server for esa.io";
    homepage = "https://github.com/esaio/esa-mcp-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sei40kr ];
    mainProgram = "esa-mcp-server";
  };
})
