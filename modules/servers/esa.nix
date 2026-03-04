{ mkServerModule, ... }:
{
  imports = [
    (mkServerModule {
      name = "esa";
      packageName = "esa-mcp-server";
    })
  ];
}
