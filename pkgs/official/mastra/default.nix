{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  nodejs_22,
  makeWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mastra-mcp-docs-server";
  version = "0.13.48";

  src = fetchFromGitHub {
    owner = "mastra-ai";
    repo = "mastra";
    rev = "0d63ec4dd389353b5d3cbad940ba674deaef0185";
    hash = "sha256-e0jsdNsfjkqi14YPRZ53E11rmLccjOsGzxLbNm9Fu1w=";
  };

  pnpmWorkspaces = [ "@mastra/mcp-docs-server..." ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src pnpmWorkspaces;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-RLBONh6Tw2Knp3+1a3mlqvMOhUOh2fWF21JTDsS6o3s=";
  };

  nativeBuildInputs = [
    nodejs_22
    pnpmConfigHook
    pnpm_10
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild

    # Disable turbo caching and daemon for reproducible Nix builds
    # TURBO_FORCE: bypass cache for all tasks
    # TURBO_NO_UPDATE_NOTIFIER: suppress update checks
    # TURBO_DAEMON: disable daemon to prevent background processes holding file locks
    # These settings prevent "cannot unlink directory not empty" errors on macOS CI
    export TURBO_FORCE=true
    export TURBO_NO_UPDATE_NOTIFIER=1
    export TURBO_DAEMON=0

    # Use turbo to build with proper dependency ordering
    # Exclude problematic internal tooling packages
    pnpm turbo build \
      --filter="@mastra/mcp-docs-server..." \
      --filter="!@internal/external-types" \
      --filter="!@internal/*" \
      --no-daemon

    # Clean up turbo cache directories to prevent cleanup failures
    rm -rf .turbo node_modules/.cache/turbo || true

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib/mastra-mcp-docs-server}

    # Copy node_modules and workspace packages to preserve symlinks
    cp -r node_modules $out/lib/mastra-mcp-docs-server/
    cp -r packages $out/lib/mastra-mcp-docs-server/

    makeWrapper ${nodejs_22}/bin/node $out/bin/mcp-server-mastra \
      --add-flags "$out/lib/mastra-mcp-docs-server/packages/mcp-docs-server/dist/stdio.js"
    runHook postInstall
  '';

  meta = {
    description = "Mastra MCP docs server - AI access to Mastra.ai documentation";
    homepage = "https://mastra.ai";
    license = lib.licenses.asl20;
    maintainers = [
      {
        github = "takeokunn";
        githubId = 11222510;
        name = "takeokunn";
      }
    ];
    mainProgram = "mcp-server-mastra";
  };
})
