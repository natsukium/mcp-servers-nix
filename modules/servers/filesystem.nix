{ mkServerModule, ... }:
{
  imports = [ (mkServerModule { name = "filesystem"; }) ];
}
