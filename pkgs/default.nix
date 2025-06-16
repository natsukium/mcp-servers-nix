{ pkgs, uv2nix ? null, pyproject-nix ? null, pyproject-build-systems ? null }:

let uvpkg = path: if (uv2nix != null && pyproject-nix != null && pyproject-build-systems != null) then 
  pkgs.callPackage path { 
    inherit uv2nix pyproject-nix pyproject-build-systems; python312 = pkgs.python312; 
  } else null; 
in {
  # reference servers
  mcp-server-aws-kb-retrieval = pkgs.callPackage (import ./reference/generic-ts.nix {
    service = "aws-kb-retrieval";
    workspace = "aws-kb-retrieval-server";
  }) { };
  mcp-server-brave-search = pkgs.callPackage (import ./reference/generic-ts.nix {
    service = "brave-search";
  }) { };
  mcp-server-everart = pkgs.callPackage (import ./reference/generic-ts.nix {
    service = "everart";
  }) { };
  mcp-server-everything = pkgs.callPackage (import ./reference/generic-ts.nix {
    service = "everything";
  }) { };
  mcp-server-fetch = pkgs.callPackage ./reference/fetch.nix { };
  mcp-server-filesystem = pkgs.callPackage (import ./reference/generic-ts.nix {
    service = "filesystem";
  }) { };
  mcp-server-git = pkgs.callPackage ./reference/git.nix { };
  mcp-server-github = pkgs.callPackage (import ./reference/generic-ts.nix {
    service = "github";
  }) { };
  mcp-server-gitlab = pkgs.callPackage (import ./reference/generic-ts.nix {
    service = "gitlab";
  }) { };
  mcp-server-gdrive = pkgs.callPackage (import ./reference/generic-ts.nix {
    service = "gdrive";
  }) { };
  mcp-server-google-maps = pkgs.callPackage (import ./reference/generic-ts.nix {
    service = "google-maps";
  }) { };
  mcp-server-memory = pkgs.callPackage (import ./reference/generic-ts.nix {
    service = "memory";
  }) { };
  mcp-server-postgres = pkgs.callPackage (import ./reference/generic-ts.nix {
    service = "postgres";
  }) { };
  mcp-server-puppeteer = pkgs.callPackage (import ./reference/generic-ts.nix {
    service = "puppeteer";
  }) { };
  mcp-server-redis = pkgs.callPackage (import ./reference/generic-ts.nix {
    service = "redis";
  }) { };
  mcp-server-sentry = pkgs.callPackage ./reference/sentry.nix { };
  mcp-server-sequential-thinking = pkgs.callPackage (import ./reference/generic-ts.nix {
    service = "sequential-thinking";
    workspace = "sequentialthinking";
  }) { };
  mcp-server-slack = pkgs.callPackage (import ./reference/generic-ts.nix {
    service = "slack";
  }) { };
  mcp-server-sqlite = pkgs.callPackage ./reference/sqlite.nix { };
  mcp-server-time = pkgs.callPackage ./reference/time.nix { };

  mcp-server-filesystem-safurrier-uv2nix = uvpkg ./official/mcp-server-filesystem-safurrier/uv2nix.nix;
  mcp-nixos-uv2nix = uvpkg ./official/mcp-nixos/uv2nix.nix;
  cli-mcp-server-uv2nix = uvpkg ./official/cli-mcp-server/uv2nix.nix;

  # official servers
  context7-mcp = pkgs.callPackage ./official/context7 { };
  mcp-grafana = pkgs.callPackage ./official/grafana { };
  mcp-nixos = pkgs.callPackage ./official/mcp-nixos { };
  mcp-server-filesystem-safurrier = pkgs.callPackage ./official/mcp-server-filesystem-safurrier { python311 = pkgs.python311; };
  notion-mcp-server = pkgs.callPackage ./official/notion { };
  playwright-mcp = pkgs.callPackage ./official/playwright { };
  github-mcp-server = pkgs.callPackage ./official/github { };
}
