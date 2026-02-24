{ mkServerModule, ... }:
{
  imports = [
    (mkServerModule {
      name = "context7";
      packageName = "context7-mcp";
    })
  ];
}
