{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage (finalAttrs: {
  pname = "mcp-gsheets";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "freema";
    repo = "mcp-gsheets";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jPvvhqk2eMQhkVxqXvx6iEnpc1s1uUamoYzpsDMXnOc=";
  };

  npmDepsHash = "sha256-+BEK368FgRdZ/P3h0TWOappWClCxL31NrNnqORB8iqc=";

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
