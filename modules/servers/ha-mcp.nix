{ mkServerModule, ... }:
{
  imports = [
    (mkServerModule {
      name = "ha-mcp";
      packageName = "ha-mcp";
    })
  ];
}
