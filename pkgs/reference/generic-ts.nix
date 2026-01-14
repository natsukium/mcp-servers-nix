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
  nodejs_22,
}:
buildNpmPackage {
  pname = "mcp-server-${service}";
  inherit (import ./source.nix { inherit fetchFromGitHub; }) version src;

  nodejs = nodejs_22;

  npmDepsHash = "sha256-iRPILytyloL6qRMvy2fsDdqkewyqEfcuVspwUN5Lrqw=";

  npmWorkspace = "src/${workspace}";

  env.PUPPETEER_SKIP_DOWNLOAD = true;

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
    makeWrapper "${nodejs_22}/bin/node" "$out/bin/mcp-server-${service}" \
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
