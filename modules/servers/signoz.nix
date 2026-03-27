{ mkServerModule, ... }:
{
  imports = [
    (mkServerModule {
      name = "signoz";
      packageName = "signoz-mcp-server";
    })
  ];
}