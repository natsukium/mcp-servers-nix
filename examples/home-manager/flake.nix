{
  description = "Example of home-manager integration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mcp-servers-nix = {
      url = "github:natsukium/mcp-servers-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
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
      homeConfigurations = forAllSystems (
        system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          modules = [
            mcp-servers-nix.homeManagerModules.default
            {
              home.username = "user";
              home.homeDirectory = "/home/user";
              home.stateVersion = "25.11";
              nixpkgs.config.allowUnfree = true;

              # Define MCP servers once, share across all MCP-aware programs
              # Unlike programs.mcp.servers, this uses mcp-servers-nix's declarative options
              mcp-servers.programs = {
                filesystem = {
                  enable = true;
                  args = [ "/home/user/documents" ];
                };
                playwright.enable = true;
                context7.enable = true;
              };

              # Enable the centralized MCP server registry
              programs.mcp.enable = true;

              # Each program consumes shared servers via enableMcpIntegration
              programs.claude-code = {
                enable = true;
                enableMcpIntegration = true;
              };
              programs.codex = {
                enable = true;
                enableMcpIntegration = true;
              };
              programs.opencode = {
                enable = true;
                enableMcpIntegration = true;
              };
            }
          ];
        }
      );
    };
}
