{ mkServerModule, ... }:
{
  imports = [
    (mkServerModule {
      name = "grafana";
      packageName = "mcp-grafana";
    })
  ];
}
