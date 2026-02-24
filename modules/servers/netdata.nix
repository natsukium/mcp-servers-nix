# Supports ND_MCP_BEARER_TOKEN for authenticated instances. Set via env, envFile, or passwordCommand.
{ mkServerModule, ... }:
{
  imports = [
    (mkServerModule {
      name = "netdata";
      packageName = "nd-mcp";
    })
  ];
}
