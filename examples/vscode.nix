{
  pkgs ? import <nixpkgs> { },
}:
let
  inherit (pkgs) lib;
  mcp-servers = import ../. { inherit pkgs; };
  config = mcp-servers.lib.mkConfig pkgs {
    fileName = "settings.json";
    flavor = "vscode";
    programs = {
      github = {
        enable = true;
        env = {
          GITHUB_PERSONAL_ACCESS_TOKEN = "\${input:github_token}";
        };
      };
    };
    settings.inputs = [
      {
        type = "promptString";
        id = "github_token";
        description = "GitHub Personal Access Token";
        password = true;
      }
    ];
  };
in

pkgs.writeShellScriptBin "vscode-with-mcp" ''
  dir="/tmp/mcp-servers-nix-vscode"
  ${pkgs.coreutils}/bin/mkdir -p "$dir/User"
  cat ${config} > "$dir/User/settings.json"
  ${lib.getExe pkgs.vscode} --user-data-dir "$dir" "$@"
''
