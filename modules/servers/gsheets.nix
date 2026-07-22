{ mkServerModule, ... }:
{
  imports = [
    (mkServerModule {
      name = "gsheets";
      packageName = "mcp-gsheets";
    })
  ];
}
