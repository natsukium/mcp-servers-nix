{ mkServerModule, ... }:
{
  imports = [ (mkServerModule { name = "sequential-thinking"; }) ];
}
