{ mkServerModule, ... }:
{
  imports = [ (mkServerModule {
    name = "treesitter";
  }) ];
}
