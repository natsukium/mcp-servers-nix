{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage (finalAttrs: {
  pname = "mcp-gsheets";
  version = "1.10.3";

  src = fetchFromGitHub {
    owner = "freema";
    repo = "mcp-gsheets";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6CBOfl5A4RsNIwOxz4PlSIj9qoFV6ec9RhEhCemne0w=";
  };

  npmDepsHash = "sha256-96QkoqnI7VLyrBs48FLtuLd6Getz0Xpm2pMe7pWN5lc=";

  # `npm run build` (tsup) bundles src into dist/, keeping googleapis and the
  # google-auth stack external, so the pruned production node_modules is kept
  # in the output for them to resolve at runtime.

  meta = {
    description = "MCP server for reading and writing Google Sheets via the Google Sheets API";
    homepage = "https://github.com/freema/mcp-gsheets";
    changelog = "https://github.com/freema/mcp-gsheets/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aldoborrero ];
    mainProgram = "mcp-gsheets";
  };
})
