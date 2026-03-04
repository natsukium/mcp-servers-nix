{ mkServerModule, ... }:
{
  imports = [
    (mkServerModule {
      name = "nixos";
      packageName = "mcp-nixos";
    })
  ];
}
