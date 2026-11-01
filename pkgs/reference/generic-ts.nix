{
  service,
  workspace ? service,
}:
{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  typescript,
  writeScriptBin,
  makeBinaryWrapper,
  nodejs_24,
}:
buildNpmPackage {
  pname = "mcp-server-${service}";
  inherit (import ./source.nix { inherit fetchFromGitHub; }) version src;

  nodejs = nodejs_24;

  npmDepsHash = "sha256-wnrR1mv9p8xBzArhSrOOM0l87PgBSUl2o6Th1kaAst0=";

  npmWorkspace = "src/${workspace}";

  env.PUPPETEER_SKIP_DOWNLOAD = true;

  # `npm prune --omit=dev` reruns the workspace `prepare` (tsc) after
  # @types/node, a devDependency, is gone, so the build fails.
  npmPruneFlags = [ "--ignore-scripts" ];

  # `npm ci` runs the workspace `prepare` scripts before node_modules/.bin is
  # populated, so this must run before npmConfigHook, not in preBuild. tsc 7
  # (tsgo) defaults compilerOptions.types to [], and the monorepo sets no
  # `types`, so @types/node never loads.
  postPatch = ''
    substituteInPlace tsconfig.json \
      --replace-fail '"compilerOptions": {' '"compilerOptions": { "types": ["node"],'
  '';

  nativeBuildInputs = [
    makeBinaryWrapper
    typescript
    (writeScriptBin "shx" "")
  ];

  # Workaround for npmInstallHook limitation with npm workspaces:
  # - Workspaces create symlinks in root node_modules (e.g., @modelcontextprotocol/server-* -> ../../src/*)
  # - Non-hoisted dependencies are installed in each workspace's node_modules
  # - npmInstallHook only copies files from `npm pack`, which excludes node_modules/
  # - This breaks symlinks as src/ directories are not copied to output
  # - Therefore, we must copy src/ manually and point the wrapper to src/${workspace}/dist/index.js
  #   instead of a hypothetical root-level dist/index.js
  postInstall = ''
    cp -r src "$out/lib/node_modules/@modelcontextprotocol/servers/src"
    makeWrapper "${nodejs_24}/bin/node" "$out/bin/mcp-server-${service}" \
      --add-flags "$out/lib/node_modules/@modelcontextprotocol/servers/src/${workspace}/dist/index.js"
  '';

  meta = {
    description = "Model Context Protocol Servers for ${service}";
    homepage = "https://github.com/modelcontextprotocol/servers";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "mcp-server-${service}";
  };
}
