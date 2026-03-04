{
  lib,
  fetchurl,
  buildNpmPackage,
}:

buildNpmPackage (finalAttrs: {
  pname = "slite-mcp-server";
  version = "1.3.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/slite-mcp-server/-/slite-mcp-server-${finalAttrs.version}.tgz";
    hash = "sha256-UeqQfTaRq2Wiu9R4Fonr6mM3Jrr3bhzrA3tRL+1HhBU=";
  };

  sourceRoot = "package";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-BgZdkEJn48DsOEiL0anme/HBFdyNUxU0zNlbH3dyYFo=";

  dontNpmBuild = true;

  meta = {
    description = "Slite MCP server for integrating Slite with AI assistants";
    homepage = "https://www.npmjs.com/package/${finalAttrs.pname}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ r-aizawa ];
    mainProgram = "slite-mcp-server";
  };
})
