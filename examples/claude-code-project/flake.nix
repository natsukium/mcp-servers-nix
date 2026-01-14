{
  description = "Example of Claude Code Project";

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
          };
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [ vscode ];
            shellHook =
              let
                config = mcp-servers-nix.lib.mkConfig pkgs {
                  programs = {
                    playwright.enable = true;
                    # ... other MCP configs
                  };
                };
              in
              ''
                if [ -L ".mcp.json" ]; then
                  unlink .mcp.json
                fi
                ln -sf ${config} .mcp.json
              '';
          };
        }
      );
    };
}
