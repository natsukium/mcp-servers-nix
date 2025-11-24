{
  description = "Example of Claude Code Project with flake-parts";

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
                args = [ "/home/user/projects" ];
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
                  "/home/user/obsidian-vault"
                ];
              };
            };

            # Enable specific flavors
            # Format is auto-determined for each flavor:
            # - claude: JSON
            # - codex: TOML-inline
            # - vscode: JSON
            flavors = {
              claude.enable = true;
              codex.enable = true;
              vscode.enable = true;
            };

            # Per-flavor overrides
            overrides = {
              # VSCode-specific configuration
              vscode = {
                programs.playwright.env = {
                  CUSTOM_SETTING = "vscode-value";
                };
                # VSCode-specific inputs for prompting secrets
                settings.inputs = [
                  {
                    type = "promptString";
                    id = "github_token";
                    description = "GitHub Personal Access Token";
                    password = true;
                  }
                ];
              };
              # Claude-specific configuration
              claude.programs.filesystem.args = [ "/home/user/claude-projects" ];
            };
          };

          # Use the generated devShell
          devShells.default = config.mcp-servers.devShell;

          # Or compose with your own devShell
          # devShells.default = pkgs.mkShell {
          #   buildInputs = [ pkgs.git ] ++ config.mcp-servers.packages;
          #   shellHook = config.mcp-servers.shellHook + ''
          #     echo "MCP servers configured!"
          #   '';
          # };
        };
    };
}
