{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage (finalAttrs: {
  pname = "deepl-mcp-server";
  version = "1.3.15";

  src = fetchFromGitHub {
    owner = "DeepLcom";
    repo = "deepl-mcp-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ds5eNLOX22UYetUnAMmz1/KKzhiGQy808cegc7nXMXM=";
  };

  npmDepsHash = "sha256-XmGd6IgCSs4KpX46lAZSC4xV1mZFc3IQMxTr5LLjnHY=";

  dontNpmBuild = true;

  meta = {
    description = "MCP server for DeepL translation API";
    homepage = "https://github.com/DeepLcom/deepl-mcp-server";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "deepl-mcp-server";
  };
})
