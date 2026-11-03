{ mkServerModule, ... }:
{
  imports = [
    (mkServerModule {
      name = "perplexity";
      packageName = "perplexity-mcp";
    })
  ];
}
