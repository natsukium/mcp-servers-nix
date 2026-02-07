{ pkgs }:
let
  inherit (pkgs) lib;
  # Ideally we should use `throw` for removed packages, but that breaks
  # `nix flake check` and `nix flake show`. As a workaround, we use
  # `lib.warn` with `emptyFile` to create a dummy derivation.
  warnRemoved = msg: lib.warn msg pkgs.emptyFile;
in
{
  # reference servers
  mcp-server-everything = pkgs.callPackage (import ./reference/generic-ts.nix {
    service = "everything";
  }) { };
  mcp-server-fetch = pkgs.callPackage ./reference/fetch.nix { };
  mcp-server-filesystem = pkgs.callPackage (import ./reference/generic-ts.nix {
    service = "filesystem";
  }) { };
  mcp-server-git = pkgs.callPackage ./reference/git.nix { };
  mcp-server-memory = pkgs.callPackage (import ./reference/generic-ts.nix {
    service = "memory";
  }) { };
  mcp-server-sequential-thinking = pkgs.callPackage (import ./reference/generic-ts.nix {
    service = "sequential-thinking";
    workspace = "sequentialthinking";
  }) { };
  mcp-server-time = pkgs.callPackage ./reference/time.nix { };

  # official servers
  context7-mcp = pkgs.callPackage ./official/context7 { };
  deepl-mcp-server = pkgs.callPackage ./official/deepl { };
  mastra-mcp-docs-server = pkgs.callPackage ./official/mastra { };
  nd-mcp = pkgs.callPackage ./official/netdata { };
  tavily-mcp = pkgs.callPackage ./official/tavily { };
  mcp-grafana = warnRemoved "mcp-grafana has been removed since it is now available in the nixpkgs 25.11 stable release";
  notion-mcp-server = pkgs.callPackage ./official/notion { };
  playwright-mcp = pkgs.callPackage ./official/playwright { };
  github-mcp-server = warnRemoved "github-mcp-server has been removed since it is now available in the nixpkgs 25.11 stable release";
  serena = pkgs.callPackage ./official/serena { };
  slite-mcp-server = pkgs.callPackage ./official/slite { };

  # community servers
  clickup-mcp-server = warnRemoved "clickup-mcp-server has been removed since upstream stopped distribution and switched to shareware";
}
