{
  config,
  lib,
  mkServerModule,
  ...
}:
{
  imports = [
    (mkServerModule {
      name = "mastra";
      packageName = "mastra-mcp-docs-server";
    })
  ];
}
