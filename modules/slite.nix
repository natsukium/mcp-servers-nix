{ mkServerModule, ... }:
{
  imports = [
    (mkServerModule {
      name = "slite";
      packageName = "slite-mcp-server";
    })
  ];
}
