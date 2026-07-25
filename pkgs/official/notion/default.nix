{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage (finalAttrs: {
  pname = "notion-mcp-server";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "makenotion";
    repo = "notion-mcp-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fbr1i66YmFctaZ3xu/zgfOiRm61Jh1Sh2l2+zg7tcNQ=";
  };

  npmDepsHash = "sha256-oPJVGWzQhr+NoYMueeECY+toxCp/GfaJUGKIqglcj+A=";

  meta = {
    description = "Official Notion MCP Server";
    homepage = "https://github.com/makenotion/notion-mcp-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "notion-mcp-server";
  };
})
