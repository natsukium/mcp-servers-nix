{ mkServerModule, ... }:
{
  imports = [ (mkServerModule { name = "fetch"; }) ];
}
