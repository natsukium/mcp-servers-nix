{ mkServerModule, ... }:
{
  imports = [
    (mkServerModule {
      name = "greenhouse";
      packageName = "greenhouse-mcp";
    })
  ];
}
