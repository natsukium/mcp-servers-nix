{ mkServerModule, ... }:
{
  imports = [ (mkServerModule { name = "cli-mcp-server"; }) ];
}
