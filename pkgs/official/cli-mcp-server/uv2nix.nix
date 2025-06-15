# cli-mcp-server using proper uv2nix pattern
{ pkgs, callPackage, fetchFromGitHub, python312, uv2nix, pyproject-nix, pyproject-build-systems }:

callPackage ../../reference/generic-uv2nix-proper.nix {
  pname = "cli-mcp-server";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "MladenSU";
    repo = "cli-mcp-server";
    rev = "main"; # Using main branch for now
    hash = "sha256-liWq+c8xo5G8h0M1Ad30bXYMHbAB1EHPLuyPkQkNsOQ=";
  };
  inherit pkgs python312 uv2nix pyproject-nix pyproject-build-systems;
}
