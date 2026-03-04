{ mkServerModule, ... }:
{
  imports = [ (mkServerModule { name = "memory"; }) ];
}
