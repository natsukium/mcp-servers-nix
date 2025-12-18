{
  lib,
  fetchurl,
  buildNpmPackage,
}:

buildNpmPackage (finalAttrs: {
  pname = "slite-mcp-server";
  version = "1.2.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/slite-mcp-server/-/slite-mcp-server-${finalAttrs.version}.tgz";
    hash = "sha256-mcpEOZRu+Yog+2EldlwMS86+Fwzvx7v0KVwQZjzQRU0=";
  };

  sourceRoot = "package";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-dS8IMTevO5yqKj85sE7R2LC0ddTViW3vVSRvPr6bcJg=";

  dontNpmBuild = true;

  meta = {
    description = "Slite MCP server for integrating Slite with AI assistants";
    homepage = "https://www.npmjs.com/package/${finalAttrs.pname}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ r-aizawa ];
    mainProgram = "slite-mcp-server";
  };
})
