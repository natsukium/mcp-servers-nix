{ mkServerModule, ... }:
{
  imports = [ (mkServerModule { name = "logseq"; packageName = "mcp-logseq"; }) ];
}
