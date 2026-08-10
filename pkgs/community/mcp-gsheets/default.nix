{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage (finalAttrs: {
  pname = "mcp-gsheets";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "freema";
    repo = "mcp-gsheets";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JvTkYxBvkpul7KCIFK52TNYDCyu5iKcD2URgUq0z+Vw=";
  };

  npmDepsHash = "sha256-SL7+LEuEADklV8qEj5L2WpAGfPNHV2GTyzEhUITFXA8=";

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
