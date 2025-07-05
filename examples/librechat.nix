{
  pkgs ? import <nixpkgs> { },
}:
let
  mcp-servers = import ../. { inherit pkgs; };
in
mcp-servers.lib.mkConfig pkgs {
  format = "yaml";
  fileName = "librechat.yaml";
  programs = {
    everything = {
      enable = true;
      url = "http://localhost:3001/sse";
    };
    filesystem = {
      enable = true;
      args = [ "/home/user/LibreChat/" ];
    };
  };
  settings.servers = {
    filesystem.iconPath = "/home/user/LibreChat/client/public/assets/logo.svg";
    mcp-obsidian = {
      command = "${pkgs.lib.getExe' pkgs.nodejs "npx"}";
      args = [
        "-y"
        "mcp-obsidian"
        "/path/to/obsidian/valut"
      ];
    };
  };
}
