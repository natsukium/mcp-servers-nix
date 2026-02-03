{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  nodejs_22,
  nodejs-slim_22,
  makeBinaryWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "metabase-mcp";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "metabase-mcp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-M7pYpjSn4D0lHILhsEK4IcBaTRRz0whg60ADlymlwOI=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-dc7gAG+P+8BYD45TiEW4xrC/lie3xld7s5yO1iM60GQ=";
  };

  nativeBuildInputs = [
    nodejs_22
    pnpmConfigHook
    pnpm_10
    makeBinaryWrapper
  ];

  buildPhase = ''
    runHook preBuild
    pnpm build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib/metabase-mcp}

    cp -r dist $out/lib/metabase-mcp/
    cp -r node_modules $out/lib/metabase-mcp/
    cp package.json $out/lib/metabase-mcp/

    makeWrapper ${nodejs-slim_22}/bin/node $out/bin/metabase-mcp \
      --add-flags "$out/lib/metabase-mcp/dist/index.js"
    runHook postInstall
  '';

  meta = {
    description = "MCP server for Metabase integration";
    homepage = "https://github.com/takeokunn/metabase-mcp";
    license = lib.licenses.mit;
    maintainers = [
      {
        github = "takeokunn";
        githubId = 11222510;
        name = "takeokunn";
      }
    ];
    mainProgram = "metabase-mcp";
  };
})
