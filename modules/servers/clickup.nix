{ lib, mkServerModule, ... }:
{
  imports = [
    (mkServerModule {
      name = "clickup";
      packageName = "clickup-mcp-server";
    })
  ];

  config.programs.clickup = {
    type = lib.mkDefault "http";
    url = lib.mkDefault "https://mcp.clickup.com/mcp";
  };
}
