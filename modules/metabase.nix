{ mkServerModule, ... }:
{
  imports = [
    (mkServerModule {
      name = "metabase";
      packageName = "metabase-mcp";
    })
  ];
}
