{ mkServerModule, ... }:
{
  imports = [
    (mkServerModule {
      name = "tavily";
      packageName = "tavily-mcp";
    })
  ];
}
