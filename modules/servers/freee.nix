{ mkServerModule, ... }:
{
  imports = [
    (mkServerModule {
      name = "freee";
      packageName = "freee-mcp";
    })
  ];
}
