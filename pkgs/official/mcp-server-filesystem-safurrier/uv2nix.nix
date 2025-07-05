# mcp-filesystem-safurrier using proper uv2nix pattern
{ pkgs, callPackage, fetchFromGitHub, python312, uv2nix, pyproject-nix, pyproject-build-systems }:

callPackage ../../reference/generic-uv2nix-proper.nix {
  pname = "mcp-filesystem";
  version = "0.2.0";
  src = fetchFromGitHub {
    owner = "timblaktu";
    repo = "mcp-filesystem-safurrier";
    rev = "uv"; # Using the UV branch
    hash = "sha256-3YQFi5BOCHEgOVH0QtfTu/BdzfMNdiRqwU4CgRWemXc=";
  };
  inherit pkgs python312 uv2nix pyproject-nix pyproject-build-systems;
}
