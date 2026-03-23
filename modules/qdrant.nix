{ mkServerModule, ... }:
{
  imports = [
    (mkServerModule {
      name = "qdrant";
      packageName = "mcp-qdrant";
    })
  ];
}
