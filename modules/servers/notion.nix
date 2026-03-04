{ mkServerModule, ... }:
{
  imports = [
    (mkServerModule {
      name = "notion";
      packageName = "notion-mcp-server";
    })
  ];
}
