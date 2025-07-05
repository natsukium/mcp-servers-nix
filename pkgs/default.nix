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
  mcp-server-aws-kb-retrieval = warnRemoved "mcp-server-aws-kb-retrieval has been removed as the package was archived upstream";
  mcp-server-brave-search = warnRemoved "mcp-server-brave-search has been removed as the package was archived upstream";
  mcp-server-everart = warnRemoved "mcp-server-everart has been removed as the package was archived upstream";
  mcp-server-everything = pkgs.callPackage (import ./reference/generic-ts.nix {
    service = "everything";
  }) { };
  mcp-server-fetch = pkgs.callPackage ./reference/fetch.nix { };
  mcp-server-filesystem = pkgs.callPackage (import ./reference/generic-ts.nix {
    service = "filesystem";
  }) { };
  mcp-server-git = pkgs.callPackage ./reference/git.nix { };
  mcp-server-github = warnRemoved "mcp-server-github has been removed as the package was archived upstream";
  mcp-server-gitlab = warnRemoved "mcp-server-gitlab has been removed as the package was archived upstream";
  mcp-server-gdrive = warnRemoved "mcp-server-gdrive has been removed as the package was archived upstream";
  mcp-server-google-maps = warnRemoved "mcp-server-google-maps has been removed as the package was archived upstream";
  mcp-server-memory = pkgs.callPackage (import ./reference/generic-ts.nix {
    service = "memory";
  }) { };
  mcp-server-postgres = warnRemoved "mcp-server-postgres has been removed as the package was archived upstream";
  mcp-server-puppeteer = warnRemoved "mcp-server-puppeteer has been removed as the package was archived upstream";
  mcp-server-redis = warnRemoved "mcp-server-redis has been removed as the package was archived upstream";
  mcp-server-sentry = warnRemoved "mcp-server-sentry has been removed as the package was archived upstream";
  mcp-server-slack = warnRemoved "mcp-server-slack has been removed as the package was archived upstream";
  mcp-server-sqlite = warnRemoved "mcp-server-sqlite has been removed as the package was archived upstream";
  mcp-server-sequential-thinking = pkgs.callPackage (import ./reference/generic-ts.nix {
    service = "sequential-thinking";
    workspace = "sequentialthinking";
  }) { };
  mcp-server-time = pkgs.callPackage ./reference/time.nix { };

  # official servers
  context7-mcp = pkgs.callPackage ./official/context7 { };
  mcp-grafana = pkgs.callPackage ./official/grafana { };
  notion-mcp-server = pkgs.callPackage ./official/notion { };
  playwright-mcp = pkgs.callPackage ./official/playwright { };
  github-mcp-server = pkgs.callPackage ./official/github { };
}
