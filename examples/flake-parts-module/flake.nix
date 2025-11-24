{
  description = "Example of flake-parts module";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    mcp-servers-nix = {
      # For testing: use path:../.., for production: use github:natsukium/mcp-servers-nix
      url = "path:../..";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      flake-parts,
      mcp-servers-nix,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ mcp-servers-nix.flakeModule ];

      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      perSystem =
        {
          config,
          pkgs,
          ...
        }:
        {
          # Configure MCP servers
          mcp-servers = {
            # Base configuration applied to all enabled flavors
            programs = {
              playwright.enable = true;
              filesystem = {
                enable = true;
                args = [ ".." ];
              };
            };

            # Additional settings for custom servers
            settings.servers = {
              # Add a custom MCP server not available in nixpkgs
              obsidian = {
                command = "${pkgs.nodejs}/bin/npx";
                args = [
                  "-y"
                  "mcp-obsidian"
                  "."
                ];
              };
            };

            # Flavor-specific configuration
            flavors = {
              claude-code = {
                enable = true;
                # Override filesystem args for Claude Code
                programs.filesystem.args = [ "../.." ];
              };
              vscode-workspace = {
                enable = true;
                # VSCode-specific configuration
                programs.playwright.env.CUSTOM_SETTING = "vscode-value";
              };
            };
          };

          # Use the generated devShell
          devShells.default = config.mcp-servers.devShell;

          # Or compose with your own devShell
          # devShells.default = pkgs.mkShell {
          #   buildInputs = [ pkgs.nodejs ] ++ config.mcp-servers.packages;
          #   shellHook = config.mcp-servers.shellHook + ''
          #     echo "MCP servers configured!"
          #   '';
          # };
        };
    };
}
