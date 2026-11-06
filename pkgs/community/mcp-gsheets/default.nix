{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage (finalAttrs: {
  pname = "mcp-gsheets";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "freema";
    repo = "mcp-gsheets";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rQ+EQjRiEqXX5cQaDjuNdtbRZsZQ60LFowRGx06TB1I=";
  };

  npmDepsHash = "sha256-bQJthtkOprC3XHKVMmIrrIuthctkUmTr3UNZw5F9Bzw=";

  # `npm run build` (tsup) bundles src into dist/, keeping googleapis and the
  # google-auth stack external, so the pruned production node_modules is kept
  # in the output for them to resolve at runtime.

  meta = {
    description = "MCP server for reading and writing Google Sheets via the Google Sheets API";
    homepage = "https://github.com/freema/mcp-gsheets";
    changelog = "https://github.com/freema/mcp-gsheets/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "mcp-gsheets";
  };
})
