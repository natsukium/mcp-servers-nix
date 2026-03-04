{
  mkServerModule,
  config,
  lib,
  ...
}:
{
  imports = [
    (mkServerModule {
      name = "slite";
      packageName = "slite-mcp-server";
    })
  ];

  options.programs.slite.useRemote = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = ''
      Use Slite's remote MCP server via streamable HTTP instead of the local stdio package.
      When enabled, type defaults to "http" and url defaults to "https://api.slite.com/mcp".
      Authentication is handled via OAuth by the MCP client.
    '';
  };

  config = lib.mkIf config.programs.slite.useRemote {
    programs.slite = {
      type = lib.mkDefault "http";
      url = lib.mkDefault "https://api.slite.com/mcp";
    };
  };
}
