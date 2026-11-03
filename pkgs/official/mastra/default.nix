{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchzip,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_11,
  nodejs_22,
  nodejs-slim_22,
  makeBinaryWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mastra-mcp-docs-server";
  version = "1.3.11";

  src = fetchFromGitHub {
    owner = "mastra-ai";
    repo = "mastra";
    tag = "@mastra/mcp-docs-server@${finalAttrs.version}";
    hash = "sha256-sCv43CfND0cu0LTKtVURGj7VbC6ICeSmezLpaUyTvFc=";
  };

  # With the global virtual store, node_modules links point into the pnpm
  # store under $TMPDIR, which does not survive into $out.
  postPatch = ''
    substituteInPlace pnpm-workspace.yaml \
      --replace-fail "enableGlobalVirtualStore: true" "enableGlobalVirtualStore: false"
  '';

  pnpmWorkspaces = [ "@mastra/mcp-docs-server..." ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    pnpm = pnpm_11;
    fetcherVersion = 5;
    hash = "sha256-8VjLm/30J5+XLiFKExHkUFWpMxebwX1iSaD7H8mntmY=";
  };

  nativeBuildInputs = [
    nodejs_22
    pnpmConfigHook
    pnpm_11
    makeBinaryWrapper
  ];

  env = {
    # Disable turbo caching and daemon for reproducible Nix builds
    # TURBO_FORCE: bypass cache for all tasks
    # TURBO_NO_UPDATE_NOTIFIER: suppress update checks
    # TURBO_DAEMON: disable daemon to prevent background processes holding file locks
    # These settings prevent "cannot unlink directory not empty" errors on macOS CI
    TURBO_FORCE = 1;
    TURBO_NO_UPDATE_NOTIFIER = 1;
    TURBO_DAEMON = 0;
  };

  buildPhase = ''
    runHook preBuild

    # Building through turbo would also build @mastra/mcp's test-only
    # devDependencies such as @mastra/pg, which do not build in isolation.
    # turbo's strict env mode would hide pnpm_config_pm_on_fail from tasks, and
    # pnpm would then try to download the packageManager version upstream pins.
    pnpm turbo build --filter="@mastra/core..." --no-daemon --env-mode=loose
    pnpm --filter="@mastra/mcp" run build:lib
    pnpm --filter="@mastra/mcp-docs-server" run build:cli

    cp -r ${finalAttrs.passthru.docs}/.docs packages/mcp-docs-server/.docs

    runHook postBuild
  '';

  # Clean up turbo cache directories to prevent cleanup failures
  postBuild = ''
    rm -rf .turbo node_modules/.cache/turbo || true
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/mastra-mcp-docs-server}

    # Copy node_modules and workspace packages to preserve symlinks
    cp -r node_modules $out/lib/mastra-mcp-docs-server/
    cp -r packages $out/lib/mastra-mcp-docs-server/
    # Only packages/ is copied, so links to test-only workspace devDependencies
    # under stores/ and observability/ would dangle.
    find $out/lib -xtype l -delete

    makeWrapper ${nodejs-slim_22}/bin/node $out/bin/mcp-server-mastra \
      --add-flags "$out/lib/mastra-mcp-docs-server/packages/mcp-docs-server/dist/stdio.js"
    runHook postInstall
  '';

  passthru = {
    # Generating .docs requires building the whole Docusaurus site, which in
    # turn builds most of the monorepo. The published npm tarball ships the
    # generated output for the same version.
    docs = fetchzip {
      url = "https://registry.npmjs.org/@mastra/mcp-docs-server/-/mcp-docs-server-${finalAttrs.version}.tgz";
      hash = "sha256-5FqrZ1pb+wrSrrcrVkUruGg0ZGcDsGSzn2OPVPRM5CQ=";
    };
  };

  meta = {
    description = "AI access to Mastra.ai documentation";
    homepage = "https://mastra.ai";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "mcp-server-mastra";
  };
})
