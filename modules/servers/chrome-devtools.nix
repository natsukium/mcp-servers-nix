{ mkServerModule, ... }:
{
  imports = [
    (mkServerModule {
      name = "chrome-devtools";
      packageName = "chrome-devtools-mcp";
    })
  ];
}