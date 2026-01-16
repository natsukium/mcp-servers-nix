{
  lib,
  fetchurl,
  buildNpmPackage,
  nodejs_22,
}:

buildNpmPackage (finalAttrs: {
  pname = "mastra-mcp-docs-server";
  version = "1.0.0-beta.21";

  src = fetchurl {
    url = "https://registry.npmjs.org/@mastra/mcp-docs-server/-/mcp-docs-server-${finalAttrs.version}.tgz";
    hash = "sha256-hO+0ExkSYUXKHQ7doR4S8igu7TvWe/UKm526NRrdqL8=";
  };

  sourceRoot = "package";

  postPatch = ''
    cp ${./package.json} package.json
    cp ${./package-lock.json} package-lock.json
  '';

  nodejs = nodejs_22;

  npmDepsHash = "sha256-BtzRb8SK6/GCBFGhTOOvlPPdwhaS0m66WO14ZAaijQI=";

  dontNpmBuild = true;

  postInstall = ''
    mv $out/bin/@mastra/mcp-docs-server $out/bin/mcp-docs-server
    rmdir $out/bin/@mastra
  '';

  meta = {
    description = "Mastra MCP docs server - AI access to Mastra.ai documentation";
    homepage = "https://www.npmjs.com/package/@mastra/mcp-docs-server";
    license = lib.licenses.asl20;
    maintainers = [
      {
        github = "takeokunn";
        githubId = 11222510;
        name = "takeokunn";
      }
    ];
    mainProgram = "mcp-docs-server";
  };
})
