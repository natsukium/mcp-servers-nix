{ mkServerModule, ... }:
{
  imports = [ (mkServerModule { name = "time"; }) ];
}
