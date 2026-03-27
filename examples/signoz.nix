{ pkgs, ... }:
{
  programs.signoz = {
    enable = true;
    env = {
      SIGNOZ_URL = "https://your-tenant.signoz.cloud";
    };
    passwordCommand = {
      SIGNOZ_API_KEY = [ "pass" "mcp/signoz" ];
    };
  };
}
