{
  description = "Example of VSCode workspace";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    mcp-servers-nix = {
      url = "github:natsukium/mcp-servers-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      mcp-servers-nix,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [ vscode ];
            shellHook =
              let
                config = mcp-servers-nix.lib.mkConfig pkgs {
                  fileName = "mcp.json";
                  flavor = "vscode-workspace";
                  programs = {
                    filesystem = {
                      enable = true;
                      args = [
                        # NOTE: Using builtins.getEnv requires running `nix develop` with --impure flag
                        "${toString (builtins.getEnv "PWD")}"
                      ];
                    };
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
              ''
                if [ -L ".vscode/mcp.json" ]; then
                  unlink .vscode/mcp.json
                fi
                mkdir -p .vscode
                ln -sf ${config} .vscode/mcp.json
              '';
          };
        }
      );
    };
}
