{ mkServerModule, ... }:
{
  imports = [ (mkServerModule { name = "everything"; }) ];
}
