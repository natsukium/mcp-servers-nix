{ mkServerModule, ... }:
{
  imports = [ (mkServerModule { name = "git"; }) ];
}
