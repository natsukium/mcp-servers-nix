{ mkServerModule, ... }:
{
  imports = [
    (mkServerModule {
      name = "terraform";
      packageName = "terraform-mcp-server";
    })
  ];
}
