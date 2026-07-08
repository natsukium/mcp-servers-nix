{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage (finalAttrs: {
  pname = "mcp-gsheets";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "freema";
    repo = "mcp-gsheets";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fDfsMZ2e7yr5baXsoz4MDs8jmErH60Q/w2Ixo1Eh4+o=";
  };

  npmDepsHash = "sha256-aq6E9nk6597mtXahku9cub/uU9hsSj2GjdlXeoZTAv4=";

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
