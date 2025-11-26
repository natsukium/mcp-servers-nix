{ mkServerModule, ... }:
{
  imports = [ (mkServerModule { name = "treesitter-mcp-server"; }) ];
}
