{ mkServerModule, ... }:
{
  imports = [
    (mkServerModule {
      name = "mcp-nixos";
      packageName = "mcp-nixos";
    })
  ];
}
