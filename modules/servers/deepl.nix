# Requires DEEPL_API_KEY env var. Set via env, envFile, or passwordCommand.
{ mkServerModule, ... }:
{
  imports = [
    (mkServerModule {
      name = "deepl";
      packageName = "deepl-mcp-server";
    })
  ];
}
