{ mkServerModule, ... }:
{
  imports = [ (mkServerModule { name = "google-calendar"; packageName = "google-calendar-mcp"; }) ];
}
