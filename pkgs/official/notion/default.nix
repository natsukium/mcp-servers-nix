{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage (finalAttrs: {
  pname = "notion-mcp-server";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "makenotion";
    repo = "notion-mcp-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ioZjtjf00/N3SRV8WEG7NuDVjrZXAcNr8OnUA/PkUpY=";
  };

  npmDepsHash = "sha256-VPmRy8uaKeiSTAvwDceupcHC7tIS7p3Xi8vnvQcE9SM=";

  meta = {
    description = "Official Notion MCP Server";
    homepage = "https://github.com/makenotion/notion-mcp-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "notion-mcp-server";
  };
})
