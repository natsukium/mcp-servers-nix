{
  pkgs ? import <nixpkgs> { },
}:
let
  mcp-servers = import ../. { inherit pkgs; };
in
mcp-servers.lib.mkConfig pkgs {
  programs = {
    netdata = {
      enable = true;
      args = [ "ws://localhost:19999/mcp" ];
      # For authenticated instances, use passwordCommand to set bearer token:
      # passwordCommand = {
      #   ND_MCP_BEARER_TOKEN = [ "cat" "/var/lib/netdata/mcp_dev_preview_api_key" ];
      # };
    };
  };
}
